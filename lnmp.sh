#!/bin/bash
#系统初始化
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i '/SELINUX=/c SELINUX=disabled' /etc/selinux/config
#准备yum仓库
if [ ! -f /etc/yum.repos.d/repo.tar.gz ];then
	curl -o ftp://36.134.134.165/pub/repo.tar.gz
fi
tar xf /etc/yum.repos.d/repo.tar.gz -C /etc/yum.repos.d/
yum clean all
yum makecache fast
#安装软件
yum -y install nginx
yum -y install mysql-community-server
systemctl start mysqld
systemctl enable mysqld
pass=`grep "password" /var/log/mysqld.log | awk '{print $NF}'`
mysqladmin -uroot -p"$pass" password "Wsf@2022"
systemctl restart mysqld
yum install -y php-fpm php php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash
curl -o /etc/nginx/nginx.conf ftp://36.134.134.165/pub/nginx.conf
systemctl restart nginx
systemctl restart php-fpm
cat >> /usr/share/nginx/html/index.php << eof
<?php
echo phpinfo();
?>
eof
cat >> /usr/share/nginx/html/test.php << eof
<?php
$link=mysql_connect("localhost","root","Wsf@2022");
if(!$link) echo "FAILD!error";
else echo "OK!You succeeded.";
?>
eof
