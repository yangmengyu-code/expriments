ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 1081/tcp
ufw allow 8388/tcp
ufw allow 8388/udp
ufw allow 51820/udp
ufw --force enable
ufw status

add-apt-repository ppa:longsleep/golang-backports -y
apt update
apt install golang-go -y
go version
rm /root/expriments/ss_proxy/v1.13.2.tar.gz*
rm -rf /root/expriments/ss_proxy/sing-box-1.13.2
mkdir -p /root/expriments/ss_proxy/
cd /root/expriments/ss_proxy
wget https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.2.tar.gz
tar -zxvf v1.13.2.tar.gz
cd sing-box-1.13.2/
make build -j4
make install -j4

mkdir -p /etc/sing-box /var/lib/sing-box
wget -O /var/lib/sing-box/geoip.db https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db
wget -O /var/lib/sing-box/geosite.db https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db
cp /root/expriments/ss_proxy/ss-conf/config.json /etc/sing-box/config.json
cp /root/expriments/ss_proxy/ss-conf/sing-box.service /etc/systemd/system/sing-box.service
systemctl daemon-reload
systemctl enable sing-box.service
systemctl status sing-box.service

cd
cp /root/expriments/http_proxy/3proxy-conf/3proxy.cfg /etc/3proxy/conf/3proxy.cfg
cp /root/expriments/http_proxy/3proxy-conf/passwd /etc/3proxy/conf/passwd
systemctl restart 3proxy.service
systemctl status 3proxy.service

rm -rf /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
mkdir -p /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
cd /root/expriments/ss_proxy/shadowsocks-rust-1.24.0
wget https://github.com/shadowsocks/shadowsocks-rust/releases/download/v1.24.0/shadowsocks-v1.24.0.x86_64-unknown-linux-gnu.tar.xz
tar -xvf shadowsocks-v1.24.0.x86_64-unknown-linux-gnu.tar.xz
cp ssserver /usr/local/bin/
chmod +x /usr/local/bin/ssserver

rm -rf /etc/shadowsocks-rust
mkdir -p /etc/shadowsocks-rust
cp /root/expriments/ss_proxy/ss-conf/config.json /etc/shadowsocks-rust/config.json
cp /root/expriments/ss_proxy/ss-conf/shadowsocks-rust.service /etc/systemd/system/shadowsocks-rust.service
systemctl daemon-reload
systemctl enable shadowsocks-rust.service
systemctl start shadowsocks-rust.service
systemctl --no-pager status shadowsocks-rust.service


cd
clashoff
clashtun off
/root/expriments/ss_proxy/clash-for-linux-install/clash-for-linux-install/uninstall.sh
rm -rf /root/expriments/ss_proxy/clash-for-linux-install
mkdir -p /root/expriments/ss_proxy/clash-for-linux-install
cd /root/expriments/ss_proxy/clash-for-linux-install
git clone --branch master --depth 1 https://gh-proxy.org/https://github.com/nelvko/clash-for-linux-install.git \
  && cd clash-for-linux-install \
  && printf "\n" | bash install.sh
clashoff
cd

rm /root/expriments/ss_proxy/ss-conf/proxy.yaml
vim /root/expriments/ss_proxy/ss-conf/proxy.yaml
cat /root/expriments/ss_proxy/ss-conf/proxy.yaml
clashsub update 1
clashsub add "file:///root/expriments/clash/confs/conf-IP/proxyto.yaml"
clashsub add "file:///root/expriments/ss_proxy/ss-conf/proxy.yaml"

clashsub update 1
clashtun off
clashtun on

ip rule add from 198.18.0.0/24 table main priority 100
ip rule del from 198.18.0.0/24 table main priority 100