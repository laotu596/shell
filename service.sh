#!/bin/sh
# desc: lsm03624 modified by www.webnginx.com
#-------------------cut begin-------------------------------------------
#welcome
#disable selinux
# set user

#set linux
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
 echo "selinux is disabled,you must reboot!"

#set dns
sed -i '$ a\NDS1=202.106.0.20' /etc/sysconfig/network-scripts/ifcfg-br0

# set vim
# sed -i "8 s/^/alias vi='vim'/" /root/.bashrc
# echo 'syntax on' > /root/.vimrc
 
#set zh_cn
# sed -i -e 's/^LANG=.*/LANG="zh_CN.UTF-8"/' /etc/sysconfig/i18n
#set the file limit
cat >> /etc/security/limits.conf << EOF
*           soft    nofile       65535
*           hard    nofile       65535
*           soft    nproc        65535
*           hard    nproc        65535
*           soft    nofile       65535
*           hard    nofile       65535
EOF
# ntpdate time
echo '5 * * * * /usr/sbin/ntpdate time.windows.com >/dev/null 2 >&1' >>/var/spool/cron/root
echo '4 * * * * /usr/sbin/ntpdate 202.120.2.101 >/dev/null 2 >&1' >>/var/spool/cron/root
echo '12 * * * * /usr/sbin/ntpdate time.nist.gov >/dev/null 2>&1' >>/var/spool/cron/root
service crond restart

#set service
for i in `chkconfig --list |awk '{print $1}'`;
do chkconfig $i off;
echo  chkconfig $i off;
done
for i in auditd blk-availability mdmonitor haldaemon crond network iptables irqbalance messagebus udev-post  sshd rsyslog sysstat;
do chkconfig $i --level 345 on;
echo chkconfig $i --level 345 on;
done

#set yum
#add the epel
rpm -Uvh http://mirrors.ustc.edu.cn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

#add the remi 
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
