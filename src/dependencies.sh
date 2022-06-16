#!/usr/bin/bash

debconf-set-selections <<<"postfix postfix/mailname string $MAIL_DOMAIN"
debconf-set-selections <<<"postfix postfix/main_mailer_type string 'No configuration'"

DEBIAN_FRONTEND=noninteractive apt-get update --yes
DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes
DEBIAN_FRONTEND=noninteractive apt-get install --yes \
    ufw \
    acl \
    mysql-server \
    spamassassin \
    spamass-milter \
    spamc \
    opendkim \
    opendkim-tools \
    postfix \
    postfix-mysql \
    dovecot-core \
    dovecot-imapd \
    dovecot-lmtpd \
    dovecot-mysql &&
    return

echo "Failed to install dependencies."
exit 1
