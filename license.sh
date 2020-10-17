#!/bin/sh

DA_PATH=/usr/local/directadmin
DA_CONF=$DA_PATH/conf
DA_CONF_FILE=$DA_CONF/directadmin.conf
LICENSE=/root/.license
PERL=/usr/bin/perl
SERVER="https://raw.githubusercontent.com/irf1404/Directadmin/master";
ETH="/etc/sysconfig/network-scripts/ifcfg-eth0:100";
VENET="/etc/sysconfig/network-scripts/ifcfg-venet0:100";

wget -O $LICENSE $SERVER/license.txt
IP_ADDR=`grep ^ip= $LICENSE |cut -d= -f2`;
URL=`grep ^url= $LICENSE |cut -d= -f2`;
rm -rf $LICENSE
if [ -e /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
	ifconfig eth0:100 $IP_ADDR netmask 255.0.0.0 up
	rm -rf $ETH
	wget -O $ETH "$SERVER/ifcfg"
	$PERL -pi -e "s/^DEVICE=.*/DEVICE=eth0:100/" $ETH
	$PERL -pi -e "s/^IPADDR=.*/IPADDR=$IP_ADDR/" $ETH
	$PERL -pi -e 's/^ethernet_dev=.*/ethernet_dev=eth0:100/' $DA_CONF_FILE
else
	ifconfig venet0:100 $IP_ADDR netmask 255.0.0.0 up
	rm -rf $VENET
	wget -O $VENET "$SERVER/ifcfg"
	$PERL -pi -e "s/^DEVICE=.*/DEVICE=venet0:100/" $VENET
	$PERL -pi -e "s/^IPADDR=.*/IPADDR=$IP_ADDR/" $VENET
	$PERL -pi -e 's/^ethernet_dev=.*/ethernet_dev=venet0:100/' $DA_CONF_FILE
fi
service network restart
mv $DA_CONF/license.key $DA_CONF/license.old
rm -rf $DA_CONF/license.key
wget -O $DA_CONF/license.key $URL
chmod 600 $DA_CONF/license.key
chown diradmin:diradmin $DA_CONF/license.key
service directadmin restart

exit 0;