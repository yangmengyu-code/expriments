cd
rm -rf expriments
git clone https://github.com/yangmengyu-code/expriments.git
find . -name "*.sh" -exec chmod +x {} +

/root/expriments/config.sh

cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +
/root/expriments/clash-install.sh
/root/expriments/clash-sub.sh

clashon
clashtun on
ip route flush table 100
ip rule flush table 100
ip route flush table 200
ip rule flush table 200
iptables -t mangle -F


systemctl --no-pager status 3proxy.service
systemctl --no-pager status shadowsocks-rust.service
clashoff
clashtun
clashsub ls
wg
iptables -t mangle -L -n -v
ip rule
