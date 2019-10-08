#!/bin/bash

# Disable SELinux unless running in docker container or it's disabled
getenforce | grep -q Disabled
if [ ! -f /.dockerenv -a $? -ne 0 ]; then
    setenforce 0
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/sysconfig/selinux
    sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

# Add user to system and apache basic auth
groupadd ood
useradd --create-home --gid ood ood
passwd --delete ood
usermod -a -G wheel ood
scl enable httpd24 -- htpasswd -b -c /opt/rh/httpd24/root/etc/httpd/.htpasswd ood ood

# Misc
mkdir -p /etc/ood/config/clusters.d
mkdir -p /etc/ood/config/apps/shell
