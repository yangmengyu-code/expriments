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

systemctl --no-pager status 3proxy.service
systemctl --no-pager status shadowsocks-rust.service
clashsub ls
wg
iptables -t mangle -L -n -v
ip rule
