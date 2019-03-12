#!/bin/bash
chown root:root /etc/ufw/applications.d/salt.ufw
which ufw
if [ $? -eq 0 ]; then
	ufw app update salt
	ufw allow salt
fi