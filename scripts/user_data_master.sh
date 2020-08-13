#!/bin/bash -x
set +e

hostnamectl set-hostname master${count}.${private_dns_zone}

#log output from this user_data script
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

#get the current AZ zone for aws.conf


mkdir -p /etc/aws/
printf "[Global]\nZone = $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)\n" > /etc/aws/aws.conf

# Create initial logs config.
cat > ./awslogs.conf << EOF
[general]
state_file = /var/awslogs/state/agent-state

[/var/log/messages]
log_stream_name = openshift-master-{instance_id}
log_group_name = /var/log/messages
file = /var/log/messages
datetime_format = %b %d %H:%M:%S
buffer_duration = 5000
initial_position = start_of_file

[/var/log/user-data.log]
log_stream_name = openshift-master-{instance_id}
log_group_name = /var/log/user-data.log
file = /var/log/user-data.log
EOF

# Download and run the AWS logs agent.
curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O
python ./awslogs-agent-setup.py --non-interactive --region ${region} -c ./awslogs.conf

# Start the awslogs service, also start on reboot.
# Note: Errors go to /var/log/awslogs.log
service awslogs start
chkconfig awslogs on

# OpenShift setup
# See: https://docs.openshift.org/latest/install_config/install/host_preparation.html

# Install packages required to setup OpenShift.
yum install -y wget git net-tools bind-utils iptables-services bridge-utils bash-completion httpd-tools
yum update -y

# See: https://access.redhat.com/articles/4599971
yum-config-manager --enable rhel-7-server-rhui-extras-rpms

# Docker setup. Check the version with `docker version`, should be 1.12.
yum install -y docker

# Configure the Docker storage back end to prepare and use our EBS block device.
# https://docs.openshift.org/latest/install_config/install/host_preparation.html#configuring-docker-storage
# Why xvdf? See:
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html
DOCKER_DEV=/dev/xvdb
INSTANCE_TYPE=$(curl http://169.254.169.254/latest/meta-data/instance-type)
if [[ $(echo $${INSTANCE_TYPE} | grep -c '^m5\|^c5\|^t3') -gt 0 ]] ; then
    DOCKER_DEV=/dev/nvme1n1
fi

# log disk layput
fdisk -l

cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=$${DOCKER_DEV}
VG=docker-vg
STORAGE_DRIVER=devicemapper
EOF
docker-storage-setup

# Restart docker and go to clean state as required by docker-storage-setup.
systemctl stop docker
rm -rf /var/lib/docker/*
docker-storage-setup
systemctl restart docker

# Allow the ec2-user to sudo without a tty, which is required when we run post
# install scripts on the server.
echo Defaults:ec2-user \!requiretty >> /etc/sudoers