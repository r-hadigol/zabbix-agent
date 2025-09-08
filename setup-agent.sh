#!/bin/bash

ZBX_SERVER=$1
HOSTNAME=$2

if [ -z "$ZBX_SERVER" ] || [ -z "$HOSTNAME" ]; then
    echo "Usage: $0 <Zabbix_Server_IP> <Hostname>"
    exit 1
fi

# آپدیت و نصب پیش‌نیازها
apt update -y
apt install -y wget apt-transport-https

# دانلود و نصب ریپوی Zabbix 7.0 LTS
rm -f /tmp/zabbix-release.deb
wget -O /tmp/zabbix-release.deb https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest+ubuntu24.04_all.deb
dpkg -i /tmp/zabbix-release.deb || { echo "Failed to install Zabbix repo"; exit 1; }
apt update -y

# نصب Zabbix Agent
apt install -y zabbix-agent || { echo "Failed to install zabbix-agent"; exit 1; }

# ویرایش فایل کانفیگ
CONFIG_FILE=/etc/zabbix/zabbix_agentd.conf
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

sed -i "s/^Server=.*/Server=$ZBX_SERVER/" $CONFIG_FILE
sed -i "s/^ServerActive=.*/ServerActive=$ZBX_SERVER/" $CONFIG_FILE
sed -i "s/^Hostname=.*/Hostname=$HOSTNAME/" $CONFIG_FILE

# فعال‌سازی و استارت سرویس
systemctl enable --now zabbix-agent

echo "Zabbix Agent installed and configured successfully!"
echo "Server: $ZBX_SERVER"
echo "Hostname: $HOSTNAME"

