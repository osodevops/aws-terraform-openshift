#!/bin/bash -x
set +e

######### Install OCP and its prerequisits
rm -fr /var/cache/yum/*
yum clean all
yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum update -y
yum install -y  openshift-ansible