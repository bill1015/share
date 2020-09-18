#!/bin/bash
masterip="x.x.x.x"
slaveip="x.x.x.x"

envinit() {
     
    if [ ! -b /dev/sdb ]; then
    	exit 1
    else
    	if [ ! -e /root/diskdone ]; then
    	   pvcreate /dev/sdb
    	   vgcreate MysqlData /dev/sdb
    	   lvcreate -n LV_data -l 100%FREE MysqlData
    	   mkfs.ext4 /dev/MysqlData/LV_data
    	   mkdir -pv /data/mysql 
    	   echo "/dev/MysqlData/LV_data  /data/mysql   ext4   defaults  0  0   " >> /etc/fstab 
    	   mount -a > /dev/null 2>&1	
    	fi
    fi
}
mysqlinit() {
    yum install mariadb mariadb-server -yum
	mount /data/mysql
	chown -R mysql:mysql /data/mysql
	if [! -e /root/mysqldone ]; then
	    cat > /etc/my.cnf <<EOF
[mysqld]
server_id=tagNum
datadir=/data/mysql
socket=/var/lib/mysql/mysql.socket
symbolic-links=0
log-bin=mysql-bin
binlog_format=mixed
expire_logs_days=5
[mysql_safe]
log-error=/data/mysql/mariadb.log
pid-file=/data/mysql/mariadb.pid 
!includedir /etc/my.cnf.d 
EOF

        ipNum=$(ifconfig | grep net | head -n1 | awk '{print $2}')
	    if ["$ipNum" == "$masterip"]; then
		   sed -i -e "s/tagNum/1/" /etc/my.cnf
		fi
	    if ["$ipNum" == "$slaveip"]; then
		   sed -i -e "s/tagNum/2/" /etc/my.cnf
		fi		
	    systemctl enable mariadb.service
		touch /root/mysqldone
	fi	
	if [ ! -e /root/dbinitiadone ]; then
		num=$(ls /data/mysql/mysqldata/data/ | wc -l) 
		if [ "$num" -ne 0]; then
		    rm -rf /data/mysql/mysqldata/data/* 
		fi
	    systemctl start mariadb.service
		   
		if [ "$ipNum" == "$masterip"]; then 
		    mysqladmin -uroot password 'Paic1234'
			mysqlroot='Paic1234'
cat > /tmp/grant.sql <<EOF
grant all privileges on *.* to 'root'@'$slaveip' identified by '';
EOF
               mysql -uroot -p$mysqlroot < /tmp/grant.sql > /tmp/mysql_masterinfo.txt
		fi
			
		if [ "$ipNum" == "$slaveip"]; then
	       mysqladmin -uroot password 'Paic1234'
		   mysqlroot='Paic1234'
cat > /tmp/grant.sql >>EOF
grant all privileges on *.* to 'root'@'$masterip' identified by '';   
EOF			   
            binLog=$(cat /tmp/mysql_masterinfo.txt | tail -n1 | awk '{print $1}')
			posId=$(cat /tmp/mysql_masterinfo.txt | tail -n1 | awk '{print $2}')
			   
			   cat > /tmp/mysqlSlavedb.sql <<EOF
stop slave;
change master to master_host='\$masterip',master_port=3306,master_root='paic1234',master_log_file='binLog',master_log_pos=posId;
start slave;
show slave status \G;
flush privileges; 			   
EOF
            sed -i -e "s/masterip/$masterip" /tmp/mysqlSlavedb.sql
			sed -i -e "s/binLog/$binLog" /tmp/mysqlSlavedb.sql
			sed -i -e "s/posId/$posId"  /tmp/mysqlSlavedb.sql
			mysql -uroot -p$mysqlroot < /tmp/grant.sql
			mysql -uroot -p$mysqlroot < /tmp/mysqlSlavedb.sql > /root/slaveStatus.txt
        fi
			touch /root/dbinitiadone
    fi	
}	


	remoteinit () {
	    if [ "$ipNum" == "$masterip"]; then 
		   passwdRoot="Paic1234"
		   expect << EOF
set timeout 30
spawn scp -o "StricHostKeyChecking no" /tmp/mysql_masterinfo.txt  root@$slaveip:/tmp/mysql_masterinfo.txt
expect "password:"
spawn scp -o "StricHostKeyChecking no" /tmp/mysqlinit.sh root@$slaveip:/tmp/mysqlinit.sh
expect "password:"
send "$(passwdRoot)\n"
expect eof 
EOF
		fi
		if [ ! -e /root/removedone]; then 
		   cd /tmp/
		   mkdir initMySQLbak
		   mv mysql* /tmp/initMySQLbak
		   mv init* /tmp/initMySQLbak
		   touch /root/removedone
		fi
        systemctl start mariadb.service			
}