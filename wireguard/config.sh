apt update
apt install wireguard -y
wg genkey | tee privatekey | wg pubkey > publickey

cp /root/expriments/wireguard/confs/conf-IP/wgi.conf /etc/wireguard/wgi.conf
wg-quick up wgi
rm /etc/wireguard/wg0.conf
vim /etc/wireguard/wg0.conf

echo "net.ipv4.ip_forward=1" | tee -a /etc/sysctl.conf
sysctl -p
sysctl -n net.ipv4.ip_forward
sysctl -w net.ipv4.ip_forward=1

sysctl -n net.ipv4.ip_forward
iptables -t nat -L -n -v
iptables -L FORWARD -n -v

cat /etc/wireguard/wg0.conf
wg-quick down wg0
wg-quick up wg0
wg-quick down wg0
systemctl status wg-quick@wg0
systemctl restart wg-quick@wg0

sysctl -w net.ipv4.ip_forward=1
iptables -A FORWARD -i wg0 -j ACCEPT
iptables -A FORWARD -o wg0 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o enp1s0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=0
iptables -F FORWARD
iptables -t nat -F POSTROUTING
iptables -D FORWARD -i wg0 -j ACCEPT
iptables -D FORWARD -o wg0 -j ACCEPT


45.32.29.7
45.77.13.64
64.226.71.55
137.220.42.146

158.247.246.229 10.0.0.1
136.244.70.245 10.0.0.2
149.28.166.245 10.0.0.3

privatekey1
SCasSUgVDNWfkdaxyUw4jL99nHZ0U0NUw0enustjk2g=
publickey1
chMTB39Siz6OzOrPqgw1VSk3NGcC0lLQgzNgSUDOPX4=
privatekey2
GM/DAALqHrt3l5mlawZE/t/HwCkWzj/xpLJJ+oIVmFo=
publickey2
GbNbv40wBrT8ZmvL5c4ITsxR/DFXoBnkUGDGz9jFiWE=
privatekey3
aB/weBjlriJOxBUdXJAHrtW9T/8V+/fAWbY7TVtsaGU=
publickey3
rrY5ptQ/6VL1De2beoQtb1S1oXXbZkHiEZzkQ5MI/B0=

ip rule del fwmark 0x1 2>/dev/null

ip rule del fwmark 0x1 2>/dev/null
ip route flush table 100 2>/dev/null
iptables -t mangle -A OUTPUT -d 45.32.29.7 -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -d 45.77.13.64 -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -d 64.226.71.55 -j MARK --set-mark 1
iptables -t mangle -A OUTPUT -d 137.220.42.146 -j MARK --set-mark 1
ip rule add fwmark 0x1 table 100
ip route add default dev wg0 via 10.0.0.2 table 100
ip route flush cache