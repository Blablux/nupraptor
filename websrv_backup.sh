#!/bin/bash

# ==============================================
# Gathers all data andconfig files needed in the
# webserver, archive them and move them to a
# target destination to be rsynced.
#
# Table of contents
# 1. System variables
# 2. Functions
# 3. Main code
#   3.1. Initialization
#   3.2. Copying
#   3.3. Archiving
#   3.4. Cleaning
# ==============================================

# ==============================================
# 1. System variables (change to your taste)
# ==============================================

MYSQL_USER="YOUR_USER"
MYSQL_PASS="YOUR_PASS"
CONFIG_FILES=(/etc/nginx/nginx.conf /etc/php5/fpm/php.ini /etc/memcached.conf /etc/nginx/conf.d/php-sock.conf)

# ==============================================
# 2. Functions
# ==============================================

function senderror()
{
    if [ -d "/tmp/websrv_backup" ]; then
        rm -r "/tmp/websrv_backup" ;
    fi
    exit "$1" ;
}

# ==============================================
# 3. Main code
# ==============================================

# find current directory
scriptpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  # DEBUG: echo "$scriptpath"

# counter
missing=0

# timestamp format
timestamp="$(date +"%Y%m%d")"

# ==============================================
# 3.1. Initialization
# ==============================================

if [ ! -d "/tmp" ]; then
    senderror "/tmp can't be read!"
else
    mkdir /tmp/websrv_backup
    mkdir /tmp/websrv_backup/databases
    mkdir /tmp/websrv_backup/sites
    mkdir /tmp/websrv_backup/configs
    echo "SET autocommit=0;SET unique_checks=0;SET foreign_key_checks=0;" > /tmp/sqlhead.sql
    echo "SET autocommit=1;SET unique_checks=1;SET foreign_key_checks=1;" > /tmp/sqlend.sql
fi

# ==============================================
# 3.2. Copying
# ==============================================

# Backup config files
for i in "${CONFIG_FILES[@]}"; do
  if [ -r $i ]; then
      cp $i /tmp/websrv_backup/configs
  else
    missing=$(( missing + 1 ))
  fi
done

  # exit if we're missing all the files (missing some files is ok)
if [ $missing = ${#CONFIG_FILES[@]} ]; then
    senderror "$missing missing files"
fi

# Backup Mysql databases
for I in $(mysql -u $MYSQL_USER --password=$MYSQL_PASS -e 'show databases' -s --skip-column-names);
do
  if [ "$I" != information_schema ] || [ "$I" !=  mysql ] || [ "$I" !=  performance_schema ]  # exclude these DB
  then
    mysqldump -u $MYSQL_USER --password=$MYSQL_PASS $I | cat /tmp/sqlhead.sql - /tmp/sqlend.sql  > "$I.sql"
  fi
done

# Backup sites
cp -R /var/www/* /tmp/websrv_backup/sites/

# TODO: backup crontab
# TODO: backup scripts

# ==============================================
# 3.3. Archiving
# ==============================================

cd /tmp
tar -czf websrv.tar.gz websrv_backup
mv websrv.tar.gz "$scriptpath"/websrv$timestamp.tar.gz

# ==============================================
# 3.4. Cleaning
# ==============================================

rm /tmp/sqlhead.sql
rm /tmp/sqlend.sql
rm -r /tmp/websrv_backup/
