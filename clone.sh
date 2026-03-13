cd
rm -rf expriments
git clone https://github.com/yangmengyu-code/expriments.git
find . -name "*.sh" -exec chmod +x {} +

/root/expriments/config.sh
source /root/.bashrc

cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +


clashoff
clashtun off



systemctl --no-pager status 3proxy.service
systemctl --no-pager status shadowsocks-rust.service
clashoff
clashtun
clashsub ls
wg
iptables -t mangle -L -n -v
ip rule
