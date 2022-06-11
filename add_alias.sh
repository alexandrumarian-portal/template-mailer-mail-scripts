#!/usr/bin/bash
#
# $1 = domain
# $2 = email
# $3 = alias
#

source src/config.sh
source src/utility.sh
source src/database.sh

TYPE="alias"
DOMAIN="$1"
EMAIL="$2"
ALIAS="$3"

insert_user "$TYPE" "$DOMAIN" "$EMAIL" "$ALIAS" ""
