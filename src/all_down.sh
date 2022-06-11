#!/usr/bin/bash

systemctl stop postfix
systemctl stop opendkim
systemctl stop spamass-milter
systemctl stop spamassassin
systemctl stop dovecot
systemctl stop mysql
