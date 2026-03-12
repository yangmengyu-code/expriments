source /root/clashctl/scripts/cmd/clashctl.sh
clashoff
clashtun off
cd
node /root/expriments/direct/client/submitd.js
node /root/expriments/direct/client/submitd_b.js

iptables -t mangle -F POSTROUTING
iptables -t mangle -A POSTROUTING -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1380
# iptables -t mangle -L -v
node /root/expriments/direct/client/submitd.js
node /root/expriments/direct/client/submitd_b.js
iptables -t mangle -F POSTROUTING