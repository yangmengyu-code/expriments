ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
ufw allow 1081/tcp
ufw --force enable

rm 0.9.5.tar.gz*
rm -rf /root/3proxy-0.9.5/
wget https://github.com/3proxy/3proxy/archive/refs/tags/0.9.5.tar.gz
tar -xvzf 0.9.5.tar.gz
cd 3proxy-0.9.5/
make -f Makefile.Linux -j4
make -f Makefile.Linux install -j4

cd
cp /root/3proxy-conf/3proxy.cfg /etc/3proxy/conf/3proxy.cfg
cp /root/3proxy-conf/passwd /etc/3proxy/conf/passwd
systemctl restart 3proxy.service
systemctl status 3proxy.service