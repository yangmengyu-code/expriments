cd
clashoff
clashtun off
/root/expriments/clash/clash-for-linux-install/clash-for-linux-install/uninstall.sh
rm -rf /root/expriments/clash/clash-for-linux-install
mkdir -p /root/expriments/clash/clash-for-linux-install
cd /root/expriments/clash/clash-for-linux-install
git clone --branch master --depth 1 https://gh-proxy.org/https://github.com/nelvko/clash-for-linux-install.git \
  && cd clash-for-linux-install \
  && printf "\n" | bash install.sh
clashoff
clashtun off
cd

