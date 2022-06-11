#!/usr/bin/bash
#
# $1 = domain
# $2 = email
# $3 = password
#

source src/config.sh
source src/utility.sh
source src/database.sh

TYPE="main"
DOMAIN="$1"
EMAIL="$2"
ALIAS="$2"
PASSWORD="$(doveadm pw -u "$2" -p "$3")"

insert_user "$TYPE" "$DOMAIN" "$EMAIL" "$ALIAS" "$PASSWORD"
