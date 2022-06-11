#!/usr/bin/bash
#
# $1 = alias
#

source src/config.sh
source src/utility.sh
source src/database.sh

ALIAS="$1"

delete_alias "$ALIAS"
