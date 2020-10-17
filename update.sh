#!/bin/sh

OS=`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`;
DA_PATH=/usr/local/directadmin
DA_SCRIPT=$DA_PATH/scripts
DA_CRON=$DA_SCRIPT/directadmin_cron
FILE_CRON=/etc/cron.d/directadmin_cron
UPDATE=$DA_PATH/update.tar.gz

rm -rf $FILE_CRON
rm -rf $UPDATE
wget -O $UPDATE "https://raw.githubusercontent.com/irf1404/Directadmin/master/update.tar.gz"

if [ "$OS" == "6" ]; then
	/etc/init.d/da-popb4smtp stop
	/etc/init.d/directadmin stop
	/sbin/service da-popb4smtp stop 2>&1
	/sbin/service directadmin stop 2>&1
else
	systemctl stop directadmin.service
	systemctl stop da-popb4smtp.service
fi

cd $DA_PATH
tar xzf update.tar.gz

cd $DA_SCRIPT
./set_permissions.sh all

cp $DA_CRON $FILE_CRON
chmod 600 $FILE_CRON
chown root $FILE_CRON

echo "0 0 1,15,29 * * root /dalicense/license.sh" >> $FILE_CRON

if [ "$OS" == "6" ]; then
	/etc/init.d/da-popb4smtp start
	/etc/init.d/directadmin start
	/sbin/service da-popb4smtp start 2>&1
	/sbin/service directadmin start 2>&1
else
	systemctl start directadmin.service
	systemctl start da-popb4smtp.service
fi