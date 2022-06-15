#!/usr/bin/bash

FILE="/etc/dovecot/dovecot.conf"
backup "$FILE"
cat <<EOF >"$FILE"
dict {

}

!include conf.d/*.conf
!include_try /usr/share/dovecot/protocols.d/*.protocol
!include_try local.conf

listen = *
protocols = imap lmtp

EOF

FILE="/etc/dovecot/conf.d/10-mail.conf"
backup "$FILE"
cat <<EOF >"$FILE"
mail_location = maildir:$MAIL_HOME/%d/%n/
mail_privileged_group = $MAIL_USER

namespace inbox {
  inbox = yes
}

protocol !indexer-worker {

}

EOF

FILE="/etc/dovecot/conf.d/10-auth.conf"
backup "$FILE"
cat <<EOF >"$FILE"
disable_plaintext_auth = yes
auth_mechanisms = plain
auth_username_format = %Lu
!include auth-sql.conf.ext

EOF

FILE="/etc/dovecot/conf.d/auth-sql.conf.ext"
backup "$FILE"
cat <<EOF >"$FILE"
passdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf.ext
}

userdb {
  driver = static
  args = uid=$MAIL_USER gid=$MAIL_USER home=$MAIL_HOME/%d/%n
}

EOF

FILE="/etc/dovecot/dovecot-sql.conf.ext"
backup "$FILE"
cat <<EOF >"$FILE"
driver = mysql
connect = host=$MYSQL_MAIL_DB_HOST dbname=$MYSQL_MAIL_DB_NAME user=$MYSQL_MAIL_DB_USER password=$MYSQL_MAIL_DB_PASS
default_pass_scheme = CRYPT
password_query = SELECT email AS user, password FROM users WHERE type = 'main' AND email = '%u' AND password != '';

EOF

FILE="/etc/dovecot/conf.d/10-master.conf"
backup "$FILE"
cat <<EOF >"$FILE"
default_process_limit = 100
default_client_limit = 1000
default_vsz_limit = 256M

service imap-login {
  inet_listener imaps {
    port = 993
    ssl = yes
  }
}

service submission-login {
  inet_listener submission {
    port = 587
  }
}

service lmtp {
  unix_listener /var/spool/postfix/run/dovecot/lmtp {
    mode = 0660
    user = postfix
    group = postfix
  }
}

service imap {

}

service submission {

}

service auth {
  unix_listener /var/spool/postfix/run/dovecot/auth {
    mode = 0660
    user = postfix
    group = postfix
  }

  unix_listener auth-userdb {
    mode = 0600
    user = $MAIL_USER
  }

  user = \$default_internal_user
}

service auth-worker {
  user = $MAIL_USER
}

service dict {
  unix_listener dict {

  }
}

EOF

FILE="/etc/dovecot/conf.d/10-ssl.conf"
backup "$FILE"
cat <<EOF >"$FILE"
ssl = yes
ssl_cert = < $TLS_CERT
ssl_key = < $TLS_CERT_KEY
ssl_client_ca_dir = $TLS_CERTS
ssl_dh = < $TLS_DH
ssl_min_protocol = TLSv1.2
ssl_prefer_server_ciphers = yes

EOF
