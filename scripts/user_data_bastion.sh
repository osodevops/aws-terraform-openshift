#!/bin/bash -x
set +e

hostnamectl set-hostname bastion.${private_dns_zone}

#log output from this user_data script
exec > >(tee /var/log/user-data.log|logger -t user-data ) 2>&1

######### Install OCP and its prerequisits
rm -fr /var/cache/yum/*
yum clean all
yum install -y http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils python2-pip openssl-devel python-devel gcc libffi-devel
yum update -y

# update pip
pip install --upgrade pip

# Get the OKD 3.11 installer.
pip install -I ansible==2.6.5
cd /root/
git clone -b release-3.11 https://github.com/openshift/openshift-ansible

# pull down the Ansible files from S3
echo "Pulling down Ansible resources from S3"
pip install awscli
aws s3 cp s3://${s3_ansible_bucket}/inventory.cfg /root/inventory.cfg
aws s3 cp s3://${ssh_key_bucket}/${ssh_key_name} /root/${ssh_key_name}
chmod 600 /root/${ssh_key_name}

# Run the playbook.
ANSIBLE_HOST_KEY_CHECKING=False /bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/prerequisites.yml
ANSIBLE_HOST_KEY_CHECKING=False /bin/ansible-playbook -i ./inventory.cfg ./openshift-ansible/playbooks/deploy_cluster.yml