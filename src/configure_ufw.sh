#!/usr/bin/bash

ufw allow proto tcp to 0.0.0.0/0 port 22
ufw allow proto tcp to 0.0.0.0/0 port 25
ufw allow proto tcp to 0.0.0.0/0 port 465
ufw allow proto tcp to 0.0.0.0/0 port 587
ufw allow proto tcp to 0.0.0.0/0 port 993

yes | ufw enable
