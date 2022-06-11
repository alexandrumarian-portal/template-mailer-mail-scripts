#!/usr/bin/bash
#
# $1 = email
#

source src/config.sh
source src/utility.sh
source src/database.sh

EMAIL="$1"

delete_user "$EMAIL"
