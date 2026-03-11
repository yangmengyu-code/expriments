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

echo "Starting configuration..."
echo "================================"
echo "Configuring client..."
/root/expriments/client-config.sh
echo "================================\n\n\n"

echo "================================"
echo "Installing http proxy..."
/root/expriments/httpproxy-install.sh
echo "================================\n\n\n"

echo "================================"
echo "Installing shadowsocks..."
/root/expriments/shadowsocks-install.sh
echo "================================\n\n\n"

echo "================================"
echo "Installing clash..."
/root/expriments/clash-install.sh
echo "================================\n\n\n"

echo "================================"
echo "Configuring clash subscription..."
/root/expriments/clash-sub.sh
echo "================================\n\n\n"

echo "================================"
echo "Installing WireGuard..."
/root/expriments/wg-install.sh
echo "================================\n\n\n"

echo "================================"
echo "Configuration complete!"
# cd
# cd expriments
# git fetch --all
# git reset --hard origin/main
# find . -name "*.sh" -exec chmod +x {} +

# Direct
# /root/expriments/direct/config.sh