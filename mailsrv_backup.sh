#!/bin/bash

# ==============================================
# Gathers all config files needed in a mailserver install,
# archive them and rsync them to a target destination.
# ==============================================

function senderror()
{
    if [ -d "/tmp/mailsrv_backup" ]; then
        rm -r "/tmp/mailsrv_backup" ;
    fi
    exit "$1" ;
}

# find current directory
scriptpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$scriptpath"

# checks if we can access the /tmp directory to store files
if [ ! -d "/tmp" ]; then
    senderror "/tmp can't be read!"
else
    mkdir /tmp/mailsrv_backup
    mkdir /tmp/mailsrv_backup/config
    mkdir /tmp/mailsrv_backup/users
fi

# counter
missing=0

# copy files
if [ -r "/etc/postfix/main.cf" ]; then
    cp /etc/postfix/main.cf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/postfix/master.cf" ]; then
cp /etc/postfix/master.cf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/postfix/helo_access" ]; then
cp /etc/postfix/helo_access /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/dovecot.conf" ]; then
cp /etc/dovecot/dovecot.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/10-ssl.conf" ]; then
cp /etc/dovecot/conf.d/10-ssl.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/10-master.conf" ]; then
cp /etc/dovecot/conf.d/10-master.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/10-auth.conf" ]; then
cp /etc/dovecot/conf.d/10-auth.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/10-director.conf" ]; then
cp /etc/dovecot/conf.d/10-director.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/90-sieve.conf" ]; then
cp /etc/dovecot/conf.d/90-sieve.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/spamassassin/local.cf" ]; then
cp /etc/spamassassin/local.cf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/default/spamassassin" ]; then
cp /etc/default/spamassassin /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/20-lmtp.conf" ]; then
cp /etc/dovecot/conf.d/20-lmtp.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/dovecot/conf.d/20-managesieve.conf" ]; then
cp /etc/dovecot/conf.d/20-managesieve.conf /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/apt/apt.conf.d/02periodic" ]; then
cp /etc/apt/apt.conf.d/02periodic /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi
if [ -r "/etc/apt/apt.conf.d/50unattended-upgrades" ]; then
cp /etc/apt/apt.conf.d/50unattended-upgrades /tmp/mailsrv_backup/config
else
  missing=$(( missing + 1 ))
fi

# exit if we're missing all the files (missing some files is ok)
if [ $missing = 12 ]; then
    senderror "$missing missing files"
fi

# parse userdir for sieve rules
find "/home/"* -prune -type d | while read d; do
    users=$(basename "$d")
    mkdir "/tmp/mailsrv_backup/users/$users"
    if [ -r "$d/.dovecot.sieve" ]; then
        cp "$d/.dovecot.sieve" "/tmp/mailsrv_backup/users/$users/dovecot.sieve"
    else
        echo "did not find any sieve rules file..."
    fi
done

# archiving
cd /tmp
tar -czf mailsrv.tar.gz mailsrv_backup
mv mailsrv.tar.gz "$scriptpath"

# cleaning
rm -r /tmp/mailsrv_backup/
