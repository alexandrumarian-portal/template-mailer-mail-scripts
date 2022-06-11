#!/usr/bin/bash

mkdir -p "/etc/opendkim"
mkdir -p "/etc/opendkim/keys"

chgrp -R opendkim "/etc/opendkim/keys"
chmod g+s "/etc/opendkim/keys"
setfacl -PRdm u::rw,g::rw,o::- "/etc/opendkim/keys"

FILE="/etc/opendkim.conf"
backup "$FILE"
cat <<EOF >"$FILE"
AutoRestart                 Yes
AutoRestartRate             10/1h
Syslog			            yes
SyslogSuccess		        yes
Mode        	            sv

Canonicalization	        relaxed/simple

UMask			            007
UserID			            opendkim:opendkim

PidFile			            /run/opendkim/opendkim.pid
Socket			            inet:14291@localhost

ExternalIgnoreList          refile:/etc/opendkim/ExternalIgnoreList
InternalHosts               refile:/etc/opendkim/InternalHosts
KeyTable                    refile:/etc/opendkim/KeyTable
SigningTable                refile:/etc/opendkim/SigningTable

Mode        	            sv
OversignHeaders		        From
SignatureAlgorithm          rsa-sha256
TrustAnchorFile		        /usr/share/dns/root.key

EOF

FILE="/etc/opendkim/ExternalIgnoreList"
cat <<EOF >"$FILE"
# domain.com
# *.domain.com

EOF

FILE="/etc/opendkim/InternalHosts"
cat <<EOF >"$FILE"
# example.com
# *.example.com

EOF

FILE="/etc/opendkim/KeyTable"
cat <<EOF >"$FILE"
# mail._domainkey.example.com example.com:mail:/etc/opendkim/keys/example.com/mail.private

EOF

FILE="/etc/opendkim/SigningTable"
cat <<EOF >"$FILE"
# *@example.com mail._domainkey.example.com

EOF
