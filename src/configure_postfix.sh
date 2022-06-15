#!/usr/bin/bash

cat <<EOF >/etc/postfix/mysql-virtual-mailbox-domains.cf
hosts = $MYSQL_MAIL_DB_HOST
dbname = $MYSQL_MAIL_DB_NAME
user = $MYSQL_MAIL_DB_USER
password = $MYSQL_MAIL_DB_PASS
query = SELECT 1 FROM (SELECT DISTINCT domain FROM users WHERE domain = '%s') AS ign

EOF

cat <<EOF >/etc/postfix/mysql-virtual-mailbox-maps.cf
hosts = $MYSQL_MAIL_DB_HOST
dbname = $MYSQL_MAIL_DB_NAME
user = $MYSQL_MAIL_DB_USER
password = $MYSQL_MAIL_DB_PASS
query = SELECT 1 FROM (SELECT DISTINCT email FROM users WHERE type = 'main' AND email = '%s' AND password != '') AS ign

EOF

cat <<EOF >/etc/postfix/mysql-virtual-alias-maps.cf
hosts = $MYSQL_MAIL_DB_HOST
dbname = $MYSQL_MAIL_DB_NAME
user = $MYSQL_MAIL_DB_USER
password = $MYSQL_MAIL_DB_PASS
query = SELECT DISTINCT email FROM users WHERE type = 'alias' AND alias = '%s'

EOF
"all@asd.com"
cat <<EOF >/etc/postfix/mysql-sender-login-maps.cf
hosts = $MYSQL_MAIL_DB_HOST
dbname = $MYSQL_MAIL_DB_NAME
user = $MYSQL_MAIL_DB_USER
password = $MYSQL_MAIL_DB_PASS
query = SELECT email FROM users WHERE alias = '%s'

EOF

FILE="/etc/postfix/main.cf"
backup "$FILE"
cat <<EOF >"$FILE"
# Compatibility
compatibility_level = 3.6

# Common
biff = no
append_dot_mydomain = no
readme_directory = no

# Secruity
smtp_tls_security_level = encrypt

smtpd_tls_auth_only = yes
smtpd_tls_cert_file=$TLS_CERT
smtpd_tls_key_file=$TLS_CERT_KEY
smtpd_tls_security_level = encrypt

# Authentication
smtpd_sasl_type = dovecot
smtpd_sasl_path = run/dovecot/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous, noplaintext
smtpd_sasl_tls_security_options = noanonymous
smtpd_sender_login_maps = mysql:/etc/postfix/mysql-sender-login-maps.cf

# Alias
alias_maps =
alias_database =

# My
mydomain = $MAIL_DOMAIN
myhostname = $MAIL_DOMAIN_FQ
myorigin = $MAIL_ORIGIN
mydestination =
mynetworks =

# Mailbox
mailbox_size_limit = 1073741824

# Recipeint
recipient_delimiter = +

# Network
inet_interfaces = all
inet_protocols = ipv4

# Virtual
virtual_transport = lmtp:unix:run/dovecot/lmtp
virtual_alias_maps = mysql:/etc/postfix/mysql-virtual-alias-maps.cf
virtual_mailbox_domains = mysql:/etc/postfix/mysql-virtual-mailbox-domains.cf
virtual_mailbox_maps = mysql:/etc/postfix/mysql-virtual-mailbox-maps.cf

# Restrictions
smtpd_reject_unlisted_recipient = yes
smtpd_reject_unlisted_sender = no
smtpd_relay_before_recipient_restrictions = yes

smtpd_client_restrictions =
        permit_sasl_authenticated,
        reject_rbl_client b.barracudacentral.org,
        reject_rbl_client zen.spamhaus.org,
        reject_rbl_client bl.spamcop.net,
        permit
smtpd_helo_restrictions =
        permit_sasl_authenticated,
        reject_invalid_helo_hostname,
        reject_non_fqdn_helo_hostname,
        permit
smtpd_relay_restrictions =
        permit_sasl_authenticated,
        defer_unauth_destination,
        permit
smtpd_recipient_restrictions =
        permit_sasl_authenticated,
        reject_non_fqdn_recipient,
        reject_unknown_recipient_domain,
        reject_unverified_recipient,
        permit
smtpd_sender_restrictions =
        reject_sender_login_mismatch,
        permit_sasl_authenticated,
        reject_non_fqdn_sender,
        reject_unknown_sender_domain,
        reject_unverified_sender,
        permit

# Milter
milter_protocol = 2
milter_default_action = accept

smtpd_milters =
        unix:run/spamass/spamass.sock,
        inet:localhost:14291
non_smtpd_milters =
        unix:run/spamass/spamass.sock,
        inet:localhost:14291

EOF

FILE="/etc/postfix/master.cf"
backup "$FILE"
cat <<EOF >"$FILE"
# ==========================================================================
# service type  private unpriv  chroot  wakeup  maxproc command + args
#               (yes)   (yes)   (no)    (never) (100)
# ==========================================================================
smtp      inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/smtp
submission inet n       -       y       -       -       smtpd
  -o syslog_name=postfix/submission
  -o smtpd_tls_security_level=encrypt
  -o milter_macro_daemon_name=ORIGINATING
smtps     inet  n       -       y       -       -       smtpd
  -o syslog_name=postfix/smtps
  -o smtpd_tls_security_level=encrypt
  -o smtpd_tls_wrappermode=yes
  -o milter_macro_daemon_name=ORIGINATING
pickup    unix  n       -       y       60      1       pickup
cleanup   unix  n       -       y       -       0       cleanup
qmgr      unix  n       -       n       300     1       qmgr
#qmgr     unix  n       -       n       300     1       oqmgr
tlsmgr    unix  -       -       y       1000?   1       tlsmgr
rewrite   unix  -       -       y       -       -       trivial-rewrite
bounce    unix  -       -       y       -       0       bounce
defer     unix  -       -       y       -       0       bounce
trace     unix  -       -       y       -       0       bounce
verify    unix  -       -       y       -       1       verify
flush     unix  n       -       y       1000?   0       flush
proxymap  unix  -       -       n       -       -       proxymap
proxywrite unix -       -       n       -       1       proxymap
smtp      unix  -       -       y       -       -       smtp
relay     unix  -       -       y       -       -       smtp
  -o syslog_name=postfix/\$service_name
showq     unix  n       -       y       -       -       showq
error     unix  -       -       y       -       -       error
retry     unix  -       -       y       -       -       error
discard   unix  -       -       y       -       -       discard
local     unix  -       n       n       -       -       local
virtual   unix  -       n       n       -       -       virtual
lmtp      unix  -       -       y       -       -       lmtp
anvil     unix  -       -       y       -       1       anvil
scache    unix  -       -       y       -       1       scache
postlog   unix-dgram n  -       n       -       1       postlogd
maildrop  unix  -       n       n       -       -       pipe
  flags=DRXhu user=$MAIL_USER argv=/usr/bin/maildrop -d \${recipient}
uucp      unix  -       n       n       -       -       pipe
  flags=Fqhu user=uucp argv=uux -r -n -z -a\$sender - \$nexthop!rmail (\$recipient)
ifmail    unix  -       n       n       -       -       pipe
  flags=F user=ftn argv=/usr/lib/ifmail/ifmail -r \$nexthop (\$recipient)
bsmtp     unix  -       n       n       -       -       pipe
  flags=Fq. user=bsmtp argv=/usr/lib/bsmtp/bsmtp -t\$nexthop -f\$sender \$recipient
scalemail-backend unix -       n       n       -       2       pipe
  flags=R user=scalemail argv=/usr/lib/scalemail/bin/scalemail-store \${nexthop} \${user} \${extension}
mailman   unix  -       n       n       -       -       pipe
  flags=FRX user=list argv=/usr/lib/mailman/bin/postfix-to-mailman.py \${nexthop} \${user}

EOF

mkdir -p "$POSTFIX_RUN"
setfacl -PRdm u::rwx,g::rwx,o::- "$POSTFIX_RUN"

mkdir -p "$POSTFIX_RUN/dovecot"
chown -R dovecot:postfix "$POSTFIX_RUN/dovecot"

mkdir -p "$POSTFIX_RUN/spamass"
chown -R spamass-milter:postfix "$POSTFIX_RUN/spamass"
