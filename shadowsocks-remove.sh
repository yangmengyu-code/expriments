cd
clear
# 删除服务
systemctl stop shadowsocks-rust.service
systemctl disable shadowsocks-rust.service
systemctl daemon-reload
# 删除程序
rm -rf /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
# mkdir -p /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
# cd /root/expriments/ss_proxy/shadowsocks-rust-1.24.0

cd
# useradd -r -s /usr/sbin/nologin shadowsocks -u 999
rm -rf /etc/shadowsocks-rust
# mkdir -p /etc/shadowsocks-rust
# cp /root/expriments/ss_proxy/ss-conf/config.json /etc/shadowsocks-rust/config.json
# cp /root/expriments/ss_proxy/ss-conf/shadowsocks-rust.service /etc/systemd/system/shadowsocks-rust.service
# systemctl daemon-reload
# systemctl enable shadowsocks-rust.service
# systemctl restart shadowsocks-rust.service
# systemctl --no-pager status shadowsocks-rust.service
# iptables -t mangle -A OUTPUT -m owner --uid-owner 999 -j MARK --set-mark 999
# ip rule add fwmark 999 lookup main priority 20