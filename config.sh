#!/bin/sh

#	________________~___________________________________________________________________~
#	_______________~___________________________________________________________________~_
#	______________~___~~~~___________~~~~_____________________________________________~__
#	_____________~___~~~~_________~~~~_______________________________________________~___
#	____________~___~~~~_______~~~~_________________________________________________~____
#	___________~___~~~~_____~~~~___________________________________________________~_____
#	__________~___~~~~___~~~~__________~~~~~~~~~~~~~~~~~___~~~~____________~~~~___~______
#	_________~___~~~~~~~~~____________~~~~~~~~~~~~~~~~~___~~~~~~__________~~~~___~_______
#	________~___~~~~~~~______________~~~~________________~~~~~~~~________~~~~___~________
#	_______~___~~~~~~~~_____________~~~~________________~~~~__~~~~______~~~~___~_________
#	______~___~~~~__~~~~___________~~~~~~~~~~~~~~~~~___~~~~____~~~~____~~~~___~__________
#	_____~___~~~~____~~~~_________~~~~________________~~~~______~~~~__~~~~___~___________
#	____~___~~~~______~~~~_______~~~~________________~~~~________~~~~~~~~___~____________
#	___~___~~~~________~~~~_____~~~~~~~~~~~~~~~~~___~~~~__________~~~~~~___~_____________
#	__~___~~~~__________~~~~___~~~~~~~~~~~~~~~~~___~~~~____________~~~~___~______________
#	_~___________________________________________________________________~_______________
#	~___________________________________________________________________~________________

# Script Config For Directadmin
# Author: Nguyen Trung Hau
# Contact: ken.hdpro@gmail.com
# Facebook: http://fb.com/irf1404

DA_PATH=/usr/local/directadmin
DA_SCRIPT=$DA_PATH/scripts
DA_CONF_FILE=$DA_PATH/conf/directadmin.conf
PERL=/usr/bin/perl
SERVER="https://raw.githubusercontent.com/irf1404/Directadmin/master"
OS=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`;

if [ "$OS" == "6" ] &&  [ "$1" == "1513" ] || [ "$1" == "1530" ] || [ "$1" == "1595" ] || [ "$1" == "1604" ] || [ "$1" == "1610" ] || [ "$1" == "1613" ]; then
	# Doi Voi Cac Ban Directadmin 1513, 1530, 1595, 1604, 1610, 1613
	# La Cac Ban Duoc Build Tren He Dieu Hanh CentOS 7 64bit
	# Khi Cai Tren CentOS 6 Bat Buoc Phai Them Cac Shortcut Service
	# Neu Khong Se Khong The Thuc Thi Trong Services Monitor

	# Lam Gia Thu Muc SYSTEMD
	mkdir -p -v /usr/lib/systemd/system
	# Tao Shortcut Service
	ln -s /etc/rc.d/init.d/da-popb4smtp /usr/lib/systemd/system/da-popb4smtp.service
	ln -s /etc/rc.d/init.d/directadmin /usr/lib/systemd/system/directadmin.service
	ln -s /etc/rc.d/init.d/dovecot /usr/lib/systemd/system/dovecot.service
	ln -s /etc/rc.d/init.d/exim /usr/lib/systemd/system/exim.service
	ln -s /etc/rc.d/init.d/httpd /usr/lib/systemd/system/httpd.service
	ln -s /etc/rc.d/init.d/mysqld /usr/lib/systemd/system/mysqld.service
	ln -s /etc/rc.d/init.d/named /usr/lib/systemd/system/named.service
	ln -s /etc/rc.d/init.d/php-fpm72 /usr/lib/systemd/system/php-fpm72.service
	ln -s /etc/rc.d/init.d/proftpd /usr/lib/systemd/system/proftpd.service
	ln -s /etc/rc.d/init.d/sshd /usr/lib/systemd/system/sshd.service
	# Lam Gia Lenh SYSTEMCTL
	echo '[[ "$2" =~ ^(.*)(\.[a-z]{1,7})$ ]]' > /usr/bin/systemctl
	echo 'service ${BASH_REMATCH[1]} $1' >> /usr/bin/systemctl
	chmod 777 /usr/bin/systemctl
fi

if [ "$1" != "1443" ]; then
	# Cau Hinh Card Mang Va License
	wget -O $DA_SCRIPT/license.sh $SERVER/license.sh
	cd $DA_SCRIPT
	chmod 777 license.sh
	./license.sh
fi

# Sua Loi Ngon Ngu Tieng Viet File Manager
$PERL -pi -e 's/^LANG_ENCODING=.*/LANG_ENCODING=UTF-8/' $DA_PATH/data/skins/enhanced/lang/en/lf_standard.html

# Cau Hinh Firewall
rm -rf /etc/sysconfig/iptables
echo "*filter" >> /etc/sysconfig/iptables
echo ":INPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
echo ":FORWARD ACCEPT [0:0]" >> /etc/sysconfig/iptables
echo ":INPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
echo ":INPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
echo ":OUTPUT ACCEPT [0:0]" >> /etc/sysconfig/iptables
echo "-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p icmp -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -i lo -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m tcp --dport 20 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A OUTPUT -p tcp -m tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A OUTPUT -p tcp -m tcp --dport 20 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 2222 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 25 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 465 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p udp --dport 53 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -p tcp --dport 53 -j ACCEPT" >> /etc/sysconfig/iptables
echo "-A INPUT -j REJECT --reject-with icmp-host-prohibited" >> /etc/sysconfig/iptables
echo "-A FORWARD -j REJECT --reject-with icmp-host-prohibited" >> /etc/sysconfig/iptables
echo "COMMIT" >> /etc/sysconfig/iptables
echo "IPTABLES_MODULES=\"ip_conntrack_ftp\"" >> /etc/sysconfig/iptables-config
service iptables restart
firewall-cmd --zone=public --add-port=25/tcp --permanent
firewall-cmd --zone=public --add-port=2222/tcp --permanent
firewall-cmd --zone=public --add-port=21/tcp --permanent
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --permanent --add-port=53/tcp
firewall-cmd --permanent --add-port=53/udp
firewall-cmd --reload

# Sua Loi Quota
cd /usr/sbin
mv setquota setquota.old
touch setquota
chmod 755 setquota

# Cai Dat Let's Encrypt
cd /usr/local/directadmin/custombuild
./build clean all
if [ "$1" != "1443" ]; then
	if [ "$1" != "1482" ]; then
		grep -q 'letsencrypt=1' $DA_CONF_FILE || echo "letsencrypt=1" >> $DA_CONF_FILE
	fi
fi

if [ "$1" == "1500" ] || [ "$1" == "1501" ] || [ "$1" == "1513" ] || [ "$1" == "1514" ] || [ "$1" == "1521" ] || [ "$1" == "1530" ] || [ "$1" == "1532" ]; then
	wget -O $DA_SCRIPT/letsencrypt.sh "http://files.directadmin.com/services/all/letsencrypt/letsencrypt.sh.1.1.42"
	chown diradmin:diradmin $DA_SCRIPT/letsencrypt.sh
	chmod 700 $DA_SCRIPT/letsencrypt.sh
elif [ "$1" == "1595" ] || [ "$1" == "1604" ] || [ "$1" == "1610" ] || [ "$1" == "1613" ] || [ "$1" == "1614" ] || [ "$1" == "1615" ]; then
	./build letsencrypt
fi
grep -q 'enable_ssl_sni=1' $DA_CONF_FILE || echo "enable_ssl_sni=1" >> $DA_CONF_FILE
grep -q 'hide_brute_force_notifications=1' $DA_CONF_FILE || echo "hide_brute_force_notifications=1" >> $DA_CONF_FILE
grep -q 'brute_force_log_scanner=1' $DA_CONF_FILE || $PERL -pi -e 's/^brute_force_log_scanner=.*/brute_force_log_scanner=0/' $DA_CONF_FILE
./build php n
./build set userdir_access no
./build rewrite_confs

# Them Server Manager
wget -O /var/www/html/status.php $SERVER/status.php
chmod 644 /var/www/html/status.php
chown webapps:webapps /var/www/html/status.php

# Tu Dong Cap Nhat Ban Quyen
if [ "$1" != "1443" ]; then
	mkdir /dalicense
	cd /dalicense
	mv $DA_SCRIPT/license.sh /dalicense/license.sh
	echo "0 0 1,15,29 * * root /dalicense/license.sh" >> /etc/cron.d/directadmin_cron
fi

service directadmin restart

exit 0;