#!/usr/bin/bash

# shellcheck disable=SC2034

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
MAIL_USER_HOME="/home/maild"
MAIL_GROUP="maild"

SPAM_USER="spamd"
SPAM_USER_HOME="/home/spamd"
SPAM_GROUP="spamd"

MAIL_DOMAIN="example.com"
MAIL_DOMAIN_FQ="mail.example.com"
MAIL_ORIGIN="example.com"

DKIM_USER="opendkim"
DKIM_USER_HOME="/run/opendkim"
DKIM_GROUP="opendkim"
DKIM_CONFIG="/etc/opendkim.conf"
DKIM_DATA="/etc/opendkim"
DKIM_DATA_KEY_TABLE="$DKIM_DATA/KeyTable"
DKIM_DATA_SIGNING_TABLE="$DKIM_DATA/SigningTable"
DKIM_DATA_TRUSTED_HOSTS="$DKIM_DATA/InternalHosts"
DKIM_DATA_EXTERNAL_IGNORE_LIST="$DKIM_DATA/ExternalIgnoreList"
DKIM_DATA_KEYS="$DKIM_DATA/keys"
