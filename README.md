ansible批量部署LNMP环境  

1.在控制端安装vsftpd，启动vsftpd服务  
将修改好的nginx.conf文件放在/var/ftp/pub目录下  
chown -R ftp.ftp /var/ftp/*  
将准备好的yum仓库压缩包文件放在/var/ftp/pub目录下  
2.将安装脚本lnmp.sh拷贝到目标主机  
ansible webserver -m copy -a "src=/root/lnmp.sh dest=/root/lnmp.sh"  
这里webserver为hosts清单中定义的主机组  
3.后台执行脚本  
nohup ansible webserver -a "bash /root/lnmp.sh" &  
可以通过以下命令查看安装进度  
tailf /root/nohup.out  
4.安装完成后，浏览器访问验证  
http://ip/index.php 验证nginx能否调用php  
http://ip/test.php  验证php能否连接数据库  

这里可以再写一个for循环的脚本批量检测  
