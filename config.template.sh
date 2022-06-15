#!/usr/bin/bash

# shellcheck disable=SC2034

MAIL_DOMAIN="example.com"
MAIL_DOMAIN_FQ="mail.example.com"
MAIL_ORIGIN="example.com"

TLS_CERT="/etc/letsencrypt/live/mail.example.com/fullchain.pem"
TLS_CERT_KEY="/etc/letsencrypt/live/mail.example.com/privkey.pem"
TLS_CERTS="/etc/ssl/certs"
TLS_DH="/usr/share/dovecot/dh.pem"

MYSQL_USER="root"
MYSQL_PASS="toor"
MYSQL_MAIL_DB_HOST="127.0.0.1"
MYSQL_MAIL_DB_NAME="mailer"
MYSQL_MAIL_DB_USER="mailer"
MYSQL_MAIL_DB_PASS="mailer"

MAIL_USER="maild"
MAIL_GROUP="maild"
MAIL_HOME="/home/maild"
MAIL_RUN="/home/maild/run"

SPAM_USER="spamd"
SPAM_GROUP="spamd"
SPAM_HOME="/home/spamd"
SPAM_RUN="/home/spamd/run"

POSTFIX_USER="postfix"
POSTFIX_GROUP="postfix"
POSTFIX_HOME="/var/spool/postfix"
POSTFIX_RUN="/var/spool/postfix/run"

DKIM_USER="opendkim"
DKIM_GROUP="opendkim"
DKIM_HOME="/run/opendkim"
DKIM_RUN="/run/opendkim"
DKIM_CONFIG="/etc/opendkim.conf"
DKIM_CONFIG_DATA="/etc/opendkim"
DKIM_CONFIG_DATA_KEY_TABLE="$DKIM_CONFIG_DATA/KeyTable"
DKIM_CONFIG_DATA_SIGNING_TABLE="$DKIM_CONFIG_DATA/SigningTable"
DKIM_CONFIG_DATA_TRUSTED_HOSTS="$DKIM_CONFIG_DATA/InternalHosts"
DKIM_CONFIG_DATA_EXTERNAL_IGNORE_LIST="$DKIM_CONFIG_DATA/ExternalIgnoreList"
DKIM_CONFIG_DATA_KEYS="$DKIM_CONFIG_DATA/keys"
