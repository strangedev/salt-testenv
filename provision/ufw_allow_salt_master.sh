#!/bin/bash
chown root:root /etc/ufw/applications.d/salt.ufw
ufw app update salt
ufw allow salt