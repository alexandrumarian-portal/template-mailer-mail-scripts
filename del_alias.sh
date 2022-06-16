#!/usr/bin/bash
#
# $1 = email
# $2 = alias
#

source src/config.sh
source src/utility.sh
source src/database.sh

EMAIL="$1"
ALIAS="$2"

delete_alias "$EMAIL" "$ALIAS"
