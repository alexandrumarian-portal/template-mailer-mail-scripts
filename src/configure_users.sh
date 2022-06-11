#!/usr/bin/bash

useradd --system --user-group --shell /usr/sbin/nologin "$MAIL_USER" &&
    mkdir -p "$MAIL_USER_HOME" &&
    chown "$MAIL_USER":"$MAIL_USER" -R "$MAIL_USER_HOME"

useradd --system --user-group --shell /usr/sbin/nologin "$SPAM_USER" &&
    mkdir -p "$SPAM_USER_HOME" &&
    chown "$SPAM_USER":"$SPAM_USER" -R "$SPAM_USER_HOME"
