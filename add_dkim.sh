#!/usr/bin/bash
#
# $1 = domain
# $2 = selector
#

source src/config.sh
source src/utility.sh

DOMAIN="$1"
SELECTOR="${2:-mail}"

DOMAIN_KEYS="$DKIM_CONFIG_DATA_KEYS/$DOMAIN"
DOMAIN_KEYS_PUBLIC="$DOMAIN_KEYS/$SELECTOR.txt"
DOMAIN_KEYS_PRIVATE="$DOMAIN_KEYS/$SELECTOR.private"
DOMAIN_SELECTOR="$SELECTOR._domainkey"

mkdir -p "$DOMAIN_KEYS" &&
    [[ ! -f "$DOMAIN_KEYS_PUBLIC" ]] &&
    [[ ! -f "$DOMAIN_KEYS_PRIVATE" ]] &&
    opendkim-genkey \
        --directory "$DOMAIN_KEYS" \
        --domain "$DOMAIN" \
        --selector="$SELECTOR" &&
    chmod 770 "$DOMAIN_KEYS_PUBLIC" &&
    chmod 770 "$DOMAIN_KEYS_PRIVATE" &&
    echo "$DOMAIN_SELECTOR.$DOMAIN $DOMAIN:mail:$DOMAIN_KEYS_PRIVATE" >>"$DKIM_CONFIG_DATA_KEY_TABLE" &&
    echo "*@$DOMAIN $DOMAIN_SELECTOR.$DOMAIN" >>"$DKIM_CONFIG_DATA_SIGNING_TABLE" &&
    echo "*@$DOMAIN" >>"$DKIM_CONFIG_DATA_TRUSTED_HOSTS" &&
    echo "Add below TXT DNS record to your DNS zone under $DOMAIN_SELECTOR:" &&
    echo "$DOMAIN_SELECTOR IN TXT" &&
    cat "$DOMAIN_KEYS_PUBLIC" &&
    systemctl restart opendkim &&
    exit

echo "Failed to configure add DKIM key. Failure or may already exist." &&
    exit 1
