#!/usr/bin/bash

source src/config.sh
source src/utility.sh
source src/dependencies.sh

source src/all_down.sh
source src/configure_users.sh
source src/configure_mysql.sh
source src/configure_opendkim.sh
source src/configure_spamassassin.sh
source src/configure_dovecot.sh
source src/configure_postfix.sh
source src/configure_ufw.sh
source src/all_up.sh
