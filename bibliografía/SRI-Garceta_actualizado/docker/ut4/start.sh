#!/bin/bash
set -e
/usr/sbin/sshd
exec /usr/sbin/vsftpd /etc/vsftpd.conf
