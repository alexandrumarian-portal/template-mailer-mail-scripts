#!/usr/bin/bash

FILE="/etc/spamassassin/local.cf"
backup "$FILE"
cat <<EOF >"$FILE"
rewrite_header Subject ***** SPAM _SCORE_ *****
report_safe             0
required_score          5.0
use_bayes               1
use_bayes_rules         1
bayes_auto_learn        1
skip_rbl_checks         0
use_razor2              0
use_dcc                 0
use_pyzor               0

EOF

FILE="/etc/default/spamassassin"
backup "$FILE"
cat <<EOF >"$FILE"
OPTIONS="--create-prefs --max-children 2 --username  $SPAM_USER --helper-home-dir $SPAM_USER_HOME -s $SPAM_USER_HOME/log/spamd.log"

CRON=1
PIDFILE="$SPAM_USER_HOME/run/spamd.pid"

EOF

FILE="/etc/default/spamass-milter"
backup "$FILE"
cat <<EOF >"$FILE"
OPTIONS="-I -i 127.0.0.1 -r 5 -- -s 10485760"

SOCKET="/var/spool/postfix/run/spamass/spamass.sock"
SOCKETMODE="0660"
SOCKETOWNER="postfix:postfix"

EOF
