cd
rm -rf /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
mkdir -p /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
cd /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.24.0/shadowsocks-v1.24.0.x86_64-unknown-linux-gnu.tar.xz
tar -xvf shadowsocks-v1.24.0.x86_64-unknown-linux-gnu.tar.xz
cp ssserver /usr/local/bin/
chmod +x /usr/local/bin/ssserver

cd
rm -rf /etc/shadowsocks-rust
mkdir -p /etc/shadowsocks-rust
cp /root/expriments/ss_proxy/ss-conf/config.json /etc/shadowsocks-rust/config.json
cp /root/expriments/ss_proxy/ss-conf/shadowsocks-rust.service /etc/systemd/system/shadowsocks-rust.service
systemctl daemon-reload
systemctl enable shadowsocks-rust.service
systemctl start shadowsocks-rust.service
systemctl --no-pager status shadowsocks-rust.service
SS_USER=shadowsocks
SS_UID=$(id -u "$SS_USER")
echo "Shadowsocks UID: $SS_UID"
iptables -t mangle -F OUTPUT
iptables -t mangle -A OUTPUT -m owner --uid-owner $SS_UID -j MARK --set-mark 1
ip rule add fwmark 1 lookup main priority 20