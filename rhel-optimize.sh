#!/bin/sh

#!/bin/sh
# desc: shurli
#-------------------cut begin-------------------------------------------
#welcome




echo "-------------------------------------------------------------------------"
echo "set dns for resolv"
echo "-------------------------------------------------------------------------"
function resolv(){
a=em1
b=eth0
c=eth1
d=eth2

A=`ifconfig |grep -E 'em|eth' |awk '{print $1}'`
if [ "$A" = "$a" ]
then
   sed -i '$ a\NDS1=202.106.0.20' /etc/sysconfig/network-scripts/ifcfg-em1
#   echo $a
elif
   [ "$A" = "$b" ]
then
   sed -i '$ a\NDS1=202.106.0.20' /etc/sysconfig/network-scripts/ifcfg-eth0
#
elif
   [ "$A" = "$c" ]
then
   sed -i '$ a\NDS1=202.106.0.20' /etc/sysconfig/network-scripts/ifcfg-eth1

elif
   [ "$A" = "$d" ]
then
   sed -i '$ a\NDS1=202.106.0.20' /etc/sysconfig/network-scripts/ifcfg-eth2

else
    echo "not ifcft-eth or ifcfg-em"
fi
echo "nameserver 202.106.0.20"  >/etc/resolv.conf
}
resolv;
sleep  5

echo "-------------------------------------------------------------------------"
echo "set selinux"
echo "-------------------------------------------------------------------------"
function selinux(){
a="Enforcing"
b=`getenforce`
c="disabled"
if [ "$a"="$b" ]
then
  sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
elif ["$a"="c"]
then
   echo "not do"
fi
}
selinux;

echo "-----------------------------------------------------"
echo "shutdown firewalld && iptables"
echo "-----------------------------------------------------"

function rhel6_iptable(){
         /etc/init.d/iptables stop
}

function rhel7_firewall(){
         /usr/bin/systemctl stop firewalld.service
}



a=`cat /etc/redhat-release |awk '{print $7}'|cut -c 1`
b=6
if [ $a == $b ]
   then  rhel6_iptables;

   else  rhel7_firewall;

fi

echo "-----------------------------------------------------------------------------------------------"
echo "install some soft"
echo "-----------------------------------------------------------------------------------------------"

yum -y install cmake gcc gcc-c++ lrzsz wget zlib curl ntpdate ftp telnet tar unzip  wget dstat tmux


echo "-----------------------------------------------------------------------------------------------"
echo "set open files"
echo "-----------------------------------------------------------------------------------------------"
echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*           soft    nofile       65535
*           hard    nofile       65535
*           soft    nproc        65535
*           hard    nproc        65535
*           soft    nofile       65535
*           hard    nofile       65535
EOF

echo "---------------------------------------------------------------------------------------------"
echo "set datetime"
echo "---------------------------------------------------------------------------------------------"
echo '5 * * * * /usr/sbin/ntpdate time.windows.com >/dev/null 2 >&1' >>/var/spool/cron/root
echo '4 * * * * /usr/sbin/ntpdate 202.120.2.101 >/dev/null 2 >&1' >>/var/spool/cron/root
echo '12 * * * * /usr/sbin/ntpdate time.nist.gov >/dev/null 2>&1' >>/var/spool/cron/root

service crond restart



echo "---------------------------------------------------------------------------------------------"
echo "set ssh config"
echo "---------------------------------------------------------------------------------------------"
#sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
#sed -i 's/^GSSAPIAuthentication yes$/GSSAPIAuthentication no/' /etc/ssh/sshd_config
#sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 7428/' /etc/ssh/sshd_config
service sshd restart

#set tcp

cat>> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_fin_timeout = 30
#net.ipv4.ip_forward = 0
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOF
/sbin/sysctl -p

echo "----------------------------------------------------------------------------------------------"
echo "download epel.repo"
echo "----------------------------------------------------------------------------------------------"
curl http://mirrors.aliyun.com/repo/epel-7.repo -o epel-7.repo
