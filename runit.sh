#!/bin/bash -xe

GERRIT_CONFIG=/data/etc/gerrit.config
if [ ! -e $GERRIT_CONFIG ] ; then
  MY_IP=$(ip a show dev eth0 | grep 'inet ' | awk '{ print $2 }' | cut -d/ -f1)
  if [ -z $GERRIT_ADDR ] ; then
    GERRIT_ADDR=$MY_IP
  fi
  cp -a /gerrit/etc /data/
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
  sed -i 's/@@AUTH_TYPE@@/'$GERRIT_AUTH_TYPE'/' $GERRIT_CONFIG
fi
if [ ! -e /data/bin/gerrit.war ] ; then
  mkdir -p /data/bin
  curl -L -o /data/bin/gerrit.war https://www.gerritcodereview.com/download/gerrit-$GERRIT_VERSION.war
fi
mkdir -p /data/plugins
for plugin in $GERRIT_PLUGINS ; do
  if [ "`echo $plugin | cut -c1,2,3,4`" = "http" ] &&
     [ ! -e /data/plugins/`basename $plugin` ] ; then
    curl -o "/data/plugins/`basename $plugin`" "$plugin"
  fi
done
if [ ! -d /data/cache ] ; then
  java -jar /data/bin/gerrit.war init -d /data --batch
fi
if [ ! -d /data/index ] ; then
  java -jar /data/bin/gerrit.war reindex -d /data
fi
exec /data/bin/gerrit.sh run
