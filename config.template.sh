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

SPAM_USER="spamd"
SPAM_USER_HOME="/home/spamd"

MAIL_DOMAIN="example.com"
MAIL_DOMAIN_FQ="mail.example.com"
MAIL_ORIGIN="example.com"
