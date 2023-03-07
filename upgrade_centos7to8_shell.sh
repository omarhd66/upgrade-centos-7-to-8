#!/bin/sh

echo '
echo "======Prepare envirenment========"
date
echo "================================="

echo "nameserver 9.9.9.9" >> /etc/resolv.conf
echo "server ma.pool.ntp.org iburst" >> /etc/chrony.conf


timedatectl set-local-rtc 0
'

echo "======Prepare envirenment========"
date
echo "================================="

echo "nameserver 9.9.9.9" >> /etc/resolv.conf
echo "server ma.pool.ntp.org iburst" >> /etc/chrony.conf


timedatectl set-local-rtc 0
timedatectl set-timezone 'Africa/Casablanca'

systemctl restart chronyd
sleep 10

echo "======Install dependencies========"
date
echo "================================="

yum install epel-release -y
yum install yum-utils -y

yum install rpmconf -y
rpmconf -a
package-cleanup --leaves
package-cleanup --orphans

yum install dnf -y

sleep 4

dnf -y remove yum yum-metadata-parser
rm -Rf /etc/yum

echo "========Start dnf upgrade ========="
date
echo "================================="
dnf upgrade -y


 
dnf install http://vault.centos.org/8.5.2111/BaseOS/x86_64/os/Packages/centos-linux-repos-8-3.el8.noarch.rpm 
dnf install http://vault.centos.org/8.5.2111/BaseOS/x86_64/os/Packages/centos-linux-release-8.5-1.2111.el8.noarch.rpm 
dnf install http://vault.centos.org/8.5.2111/BaseOS/x86_64/os/Packages/centos-gpg-keys-8-3.el8.noarch.rpm


dnf -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

sleep 2

echo "======Prepare Repositories========"
date
echo "================================="

cat << EOF > /etc/yum.repos.d/CentOS-Linux-BaseOS.repo
[baseos]
name=CentOS Linux $releasever - BaseOS
#mirrorlist=http://#mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra
baseurl=http://vault.centos.org/$contentdir/$releasever/BaseOS/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF


cat << EOF >  /etc/yum.repos.d/CentOS-Linux-AppStream.repo
[appstream]
name=CentOS Linux $releasever - AppStream
#mirrorlist=http://#mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=AppStream&infra=$infra
baseurl=http://vault.centos.org/$contentdir/$releasever/AppStream/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF


cat << EOF > /etc/yum.repos.d/CentOS-Linux-Extras.repo
[extras]
name=CentOS Linux $releasever - Extras
#mirrorlist=http://#mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra
baseurl=http://vault.centos.org/$contentdir/$releasever/extras/$basearch/os/
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial
EOF



echo "======== Kernet Part =========="
date
echo "================================="

echo '
dnf clean all 

rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
dnf -y install kernel-core --allowerasing  
dnf update procps-ng

'

dnf clean all 

rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync

dnf -y install kernel-core --allowerasing  

dnf update procps-ng


echo '
rpm --rebuilddb
dnf -y update

rpm -Va --nofiles --nodigest

dnf -y groupupdate "Core" "Minimal Install"  --skip-broken
dnf clean packages
'

rpm --rebuilddb
dnf -y update

rpm -Va --nofiles --nodigest

dnf -y groupupdate "Core" "Minimal Install"  --skip-broken
dnf clean packages


