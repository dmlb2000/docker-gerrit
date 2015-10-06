#!/bin/bash -x

curl -L -o /gerrit/gerrit.war https://www.gerritcodereview.com/download/gerrit-$GERRIT_VERSION.war
MY_IP=$(ip a show dev eth0 | grep 'inet ' | awk '{ print $2 }' | cut -d/ -f1)
if [ -z $GERRIT_ADDR ] ; then
  GERRIT_ADDR=$MY_IP
fi
cp -a /gerrit/etc /data/
GERRIT_CONFIG=/data/etc/gerrit.config
sed -i 's/@@MYSQL_ADDR@@/'$MYSQL_PORT_3306_TCP_ADDR'/' $GERRIT_CONFIG
sed -i 's/@@GERRIT_ADDR@@/'$GERRIT_ADDR'/' $GERRIT_CONFIG
java -jar /gerrit/gerrit.war init -d /data --batch
java -jar /gerrit/gerrit.war reindex -d /data
/data/bin/gerrit.sh supervise
