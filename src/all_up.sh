#!/usr/bin/bash

systemctl start mysql
systemctl start dovecot
systemctl start spamassassin
systemctl start spamass-milter
systemctl start opendkim
systemctl start postfix

systemctl enable mysql
systemctl enable dovecot
systemctl enable spamassassin
systemctl enable spamass-milter
systemctl enable opendkim
systemctl enable postfix
