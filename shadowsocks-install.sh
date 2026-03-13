cd
rm -rf /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
mkdir -p /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
cd /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.24.0/shadowsocks-v1.24.0.x86_64-unknown-linux-gnu.tar.xz
tar -xvf shadowsocks-v1.24.0.x86_64-unknown-linux-gnu.tar.xz
cp ssserver /usr/local/bin/
chmod +x /usr/local/bin/ssserver

cd
useradd -r -s /usr/sbin/nologin shadowsocks
rm -rf /etc/shadowsocks-rust
mkdir -p /etc/shadowsocks-rust
cp /root/expriments/ss_proxy/ss-conf/config.json /etc/shadowsocks-rust/config.json
cp /root/expriments/ss_proxy/ss-conf/shadowsocks-rust.service /etc/systemd/system/shadowsocks-rust.service
systemctl daemon-reload
systemctl enable shadowsocks-rust.service
systemctl restart shadowsocks-rust.service
systemctl --no-pager status shadowsocks-rust.service
# SS_USER=shadowsocks
# SS_UID=$(id -u "$SS_USER")
# echo "Shadowsocks UID: $SS_UID"
# iptables -t mangle -F OUTPUT
# id -u shadowsocks
iptables -t mangle -A OUTPUT -m owner --uid-owner shadowsocks -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -m owner --uid-owner 999 -j MARK --set-mark 1
iptables -t mangle -L -n -v
iptables -t mangle -F

ip rule add to 0.0.0.0/0 lookup 200 priority 10 || true
ip rule add from 182.168.0.0/30 table 200 priority 10 || true
ip rule del fwmark 1 lookup 200 priority 10 || true
ip route flush table 200 || true
ip route add default dev enp1s0 table 200 || true
ip route flush cache
sysctl -w net.ipv4.ip_forward=1
sysctl -w net.ipv4.conf.all.rp_filter=0
sysctl -w net.ipv4.conf.default.rp_filter=0
sysctl -w net.ipv4.conf.enp1s0.rp_filter=0