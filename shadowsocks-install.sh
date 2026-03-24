cd
clear
apt install shadowsocks-libev
cp /root/expriments/ss_proxy/ss-conf/config.json /etc/shadowsocks-libev/config.json
systemctl restart shadowsocks-libev
systemctl enable shadowsocks-libev
systemctl --no-pager status shadowsocks-libev