ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 1081/tcp
ufw allow 8388/tcp
ufw allow 8388/udp
ufw allow 51820/udp
ufw --force enable
apt update
apt install git make gcc build-essential -y

printf "Starting configuration...\n"
printf "================================\n"
printf "Configuring client...\n"
/root/expriments/client-config.sh
printf "================================\n\n\n"

printf "================================\n"
printf "Installing http proxy...\n"
/root/expriments/httpproxy-install.sh
printf "================================\n\n\n"

printf "================================\n"
printf "Installing shadowsocks...\n"
/root/expriments/shadowsocks-install.sh
printf "================================\n\n\n"

printf "================================\n"
printf "Installing clash...\n"
/root/expriments/clash-install.sh
printf "================================\n\n\n"

printf "================================\n"
printf "Configuring clash subscription...\n"
/root/expriments/clash-sub.sh
printf "================================\n\n\n"

printf "================================\n"
printf "Installing WireGuard...\n"
/root/expriments/wg-install.sh
printf "================================\n\n\n"

printf "================================\n"
printf "Configuration complete!\n"
# cd
# cd expriments
# git fetch --all
# git reset --hard origin/main
# find . -name "*.sh" -exec chmod +x {} +

# Direct
# /root/expriments/direct/config.sh