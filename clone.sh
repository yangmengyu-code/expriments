clear
cd
rm -rf expriments
git clone https://github.com/yangmengyu-code/expriments.git
find . -name "*.sh" -exec chmod +x {} +

/root/expriments/config.sh
source /root/.bashrc

clear
cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +


clashoff
clashtun off


clear
npx playwright --version
npx playwright install --list
systemctl --no-pager status 3proxy.service
systemctl --no-pager status shadowsocks-rust.service
clashoff
clashtun
clashsub ls
wg
iptables -t mangle -L -n -v
ip rule