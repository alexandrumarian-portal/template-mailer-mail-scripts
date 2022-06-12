#!/usr/bin/bash

systemctl start mysql

# MySQL
mysql <<EOF
ALTER USER '$MYSQL_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASS'

EOF

mysql_secure_installation --user="$MYSQL_USER" --password="$MYSQL_PASS" <<EOF
n
n
y
y
y
y

EOF

mysql --user="$MYSQL_USER" --password="$MYSQL_PASS" <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_MAIL_DB_NAME;

CREATE USER IF NOT EXISTS '$MYSQL_MAIL_DB_USER'@'$MYSQL_MAIL_DB_HOST' IDENTIFIED BY '$MYSQL_MAIL_DB_PASS';
GRANT SELECT ON $MYSQL_MAIL_DB_NAME.* TO '$MYSQL_MAIL_DB_USER'@'$MYSQL_MAIL_DB_HOST';
FLUSH PRIVILEGES;

USE $MYSQL_MAIL_DB_NAME;

CREATE TABLE IF NOT EXISTS users (
  id int(11) NOT NULL auto_increment,
  type enum('main', 'alias') NOT NULL,
  domain varchar(256) NOT NULL,
  email varchar(256) NOT NULL,
  alias varchar(256) NOT NULL,
  password varchar(1024) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (type, domain, email, alias),
  UNIQUE KEY (email, alias)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

EOF

systemctl stop mysql
