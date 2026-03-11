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

printf "Starting configuration..."
printf "================================"
printf "Configuring client..."
/root/expriments/client-config.sh
printf "================================\n\n\n"

printf "================================"
printf "Installing http proxy..."
/root/expriments/httpproxy-install.sh
printf "================================\n\n\n"

printf "================================"
printf "Installing shadowsocks..."
/root/expriments/shadowsocks-install.sh
printf "================================\n\n\n"

printf "================================"
printf "Installing clash..."
/root/expriments/clash-install.sh
printf "================================\n\n\n"

printf "================================"
printf "Configuring clash subscription..."
/root/expriments/clash-sub.sh
printf "================================\n\n\n"

printf "================================"
printf "Installing WireGuard..."
/root/expriments/wg-install.sh
printf "================================\n\n\n"

printf "================================"
printf "Configuration complete!"
# cd
# cd expriments
# git fetch --all
# git reset --hard origin/main
# find . -name "*.sh" -exec chmod +x {} +

# Direct
# /root/expriments/direct/config.sh