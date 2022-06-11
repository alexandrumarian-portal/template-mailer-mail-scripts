#!/usr/bin/bash

function insert_user() {
    local TYPE="$1"
    local DOMAIN="$2"
    local EMAIL="$3"
    local ALIAS="$4"
    local PASSWORD="$5"

    mysql --user="$MYSQL_USER" --password="$MYSQL_PASS" <<EOF
USE $MYSQL_MAIL_DB_NAME;

INSERT INTO users (
    type,
    domain,
    email,
    alias,
    password
) VALUES (
    '$TYPE',
    '$DOMAIN',
    '$EMAIL',
    '$ALIAS',
    '$PASSWORD'
);

EOF
}

function delete_user() {
    local EMAIL="$1"

    mysql --user="$MYSQL_USER" --password="$MYSQL_PASS" <<EOF
USE $MYSQL_MAIL_DB_NAME;

DELETE FROM users WHERE email = '$EMAIL';

EOF
}

function delete_alias() {
    local ALIAS="$1"

    mysql --user="$MYSQL_USER" --password="$MYSQL_PASS" <<EOF
USE $MYSQL_MAIL_DB_NAME;

DELETE FROM users WHERE type = 'alias' AND alias = '$ALIAS';

EOF
}
