rm /root/expriments/socks5/v1.0.5.tar.gz*
rm -rf /root/expriments/socks5/microsocks-1.0.5/
cd /root/expriments/socks5/
wget https://github.com/rofl0r/microsocks/archive/refs/tags/v1.0.5.tar.gz
tar -xzf v1.0.5.tar.gz
cd microsocks-1.0.5
make -j4
make install -j4

nohup microsocks -p 1083 -u root -P m123456 > /dev/null 2>&1 &


npm install proxy-chain