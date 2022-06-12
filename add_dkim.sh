#!/usr/bin/bash
#
# $1 = domain
# $2 = selector
#

source src/config.sh
source src/utility.sh

DOMAIN="$1"
SELECTOR="${2:-mail}"

DOMAIN_KEYS="$DKIM_DATA_KEYS/$DOMAIN"
DOMAIN_KEYS_PUBLIC="$DOMAIN_KEYS/$SELECTOR.txt"
DOMAIN_KEYS_PRIVATE="$DOMAIN_KEYS/$SELECTOR.private"
DOMAIN_SELECTOR="$SELECTOR._domainkey"

mkdir "$DOMAIN_KEYS" &&
    opendkim \
        --directory "$DOMAIN_KEYS" \
        --domain "$DOMAIN" \
        --selector="$SELECTOR" &&
    echo "$DOMAIN_SELECTOR.$DOMAIN $DOMAIN:mail:$DOMAIN_KEYS_PRIVATE" >>"$DKIM_DATA_KEY_TABLE" &&
    echo "*@$DOMAIN $DOMAIN_SELECTOR.$DOMAIN" >>"$DKIM_DATA_SIGNING_TABLE" &&
    echo "*@$DOMAIN" >>"$DKIM_DATA_IGNORE_HOSTS" &&
    echo "Add below TXT DNS record to your DNS zone under $DOMAIN_SELECTOR:" &&
    echo "$DOMAIN_SELECTOR IN TXT" &&
    echo "v=DKIM1; k=rsa; p=$(cat "$DOMAIN_KEYS_PUBLIC")" &&
    systemctl restart opendkim &&
    exit

echo "Failed to configure add DKIM key." &&
    exit 1
