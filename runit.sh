#!/bin/bash -x

curl -L -o /tmp/gerrit.war https://www.gerritcodereview.com/download/gerrit-$GERRIT_VERSION.war
MY_IP=$(ip a show dev eth0 | grep 'inet ' | awk '{ print $2 }' | cut -d/ -f1)
if [ -z $GERRIT_ADDR ] ; then
  GERRIT_ADDR=$MY_IP
fi
cp -a /gerrit/etc /data/
GERRIT_CONFIG=/data/etc/gerrit.config
if [[ -z $MAIL_USER ]] ; then
  MAIL_USER=$(echo $MAIL_ENV_smtp_user | cut -d: -f1)
fi
if [[ -z $MAIL_PASS ]] ; then
  MAIL_PASS=$(echo $MAIL_ENV_smtp_user | cut -d: -f2)
fi
sed -i 's/@@MYSQL_ADDR@@/'$MYSQL_PORT_3306_TCP_ADDR'/' $GERRIT_CONFIG
sed -i 's/@@GERRIT_ADDR@@/'$GERRIT_ADDR'/' $GERRIT_CONFIG
sed -i 's/@@MAIL_ADDR@@/'$MAIL_PORT_25_TCP_ADDR'/' $GERRIT_CONFIG
sed -i 's/@@MAIL_USER@@/'$MAIL_USER'/' $GERRIT_CONFIG
sed -i 's/@@MAIL_PASS@@/'$MAIL_PASS'/' $GERRIT_CONFIG
sed -i 's/@@AUTH_TYPE@@/'$AUTH_TYPE'/' $GERRIT_CONFIG
java -jar /tmp/gerrit.war init -d /data --batch
java -jar /tmp/gerrit.war reindex -d /data
/data/bin/gerrit.sh supervise
