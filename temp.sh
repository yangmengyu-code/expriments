clear
cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +
/root/expriments/shadowsocks-install.sh

clear
cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +
clashsub update 1
clashsub add file:///root/expriments/temp1.yaml
clashsub use 1

clashon
clashtun on
clashoff
clashtun off

node /root/expriments/direct/client/submitd.js
clear
cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +
clashsub add file:///root/expriments/temp2.yaml