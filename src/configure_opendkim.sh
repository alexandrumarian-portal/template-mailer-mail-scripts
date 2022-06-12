#!/usr/bin/bash

mkdir -p "$DKIM_DATA"
mkdir -p "$DKIM_DATA_KEYS"

chgrp -R opendkim "$DKIM_DATA_KEYS"
chmod g+s "$DKIM_DATA_KEYS"
setfacl -PRdm u::rw,g::rw,o::- "$DKIM_DATA_KEYS"

FILE="$DKIM_CONFIG"
backup "$FILE"
cat <<EOF >"$FILE"
AutoRestart                 Yes
AutoRestartRate             10/1h
Syslog			            yes
SyslogSuccess		        yes
Mode        	            sv

Canonicalization	        relaxed/simple

UMask			            007
UserID			            $DKIM_USER:$DKIM_GROUP

PidFile			            $DKIM_USER_HOME/opendkim.pid
Socket			            inet:14291@localhost

KeyTable                    refile:$DKIM_DATA_KEY_TABLE
SigningTable                refile:$DKIM_DATA_SIGNING_TABLE
InternalHosts               refile:$DKIM_DATA_TRUSTED_HOSTS
ExternalIgnoreList          refile:$DKIM_DATA_EXTERNAL_IGNORE_LIST

Mode        	            sv
OversignHeaders		        From
SignatureAlgorithm          rsa-sha256
TrustAnchorFile		        /usr/share/dns/root.key

EOF

FILE="$DKIM_DATA_KEY_TABLE"
cat <<EOF >"$FILE"
# mail._domainkey.example.com example.com:mail:$DKIM_DATA_KEYS/example.com/mail.private

EOF

FILE="$DKIM_DATA_SIGNING_TABLE"
cat <<EOF >"$FILE"
# *@example.com mail._domainkey.example.com

EOF

FILE="$DKIM_DATA_TRUSTED_HOSTS"
cat <<EOF >"$FILE"
# example.com
# *.example.com

EOF

FILE="$DKIM_DATA_EXTERNAL_IGNORE_LIST"
cat <<EOF >"$FILE"
# domain.com
# *.domain.com

EOF
