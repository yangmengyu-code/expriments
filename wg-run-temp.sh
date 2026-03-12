wg set wg0 peer SQNasweymGDhQhgQhHHjAGix74INPibewhIxVK4xUz4= allowed-ips 10.0.0.2/32,45.32.29.7/32,45.77.13.64/32,64.226.71.55/32,137.220.42.146/32
wg set wg0 peer SQNasweymGDhQhgQhHHjAGix74INPibewhIxVK4xUz4= allowed-ips 10.0.0.2/32
wg set wg0 peer 6hDWcnWX8oSxdGlRTGx7XIHYD4CTb7FaPNbMlO2l51M= allowed-ips 10.0.0.3/32,45.32.29.7/32,45.77.13.64/32,64.226.71.55/32,137.220.42.146/32
wg set wg0 peer 6hDWcnWX8oSxdGlRTGx7XIHYD4CTb7FaPNbMlO2l51M= allowed-ips 10.0.0.3/32
wg set wg0 peer NkuX71uR/UcX/QPOEdML6hyU0VRZE6Rp6G3z3PIZ4ik= allowed-ips 10.0.0.1/32,45.32.29.7/32,45.77.13.64/32,64.226.71.55/32,137.220.42.146/32,34.117.59.81/32
wg set wg0 peer NkuX71uR/UcX/QPOEdML6hyU0VRZE6Rp6G3z3PIZ4ik= allowed-ips 10.0.0.1/32

ip rule add from 10.0.0.0/24 table main priority 100
ip rule add to 45.32.29.7 table 100 priority 200
ip rule add to 45.77.13.64 table 100 priority 200
ip rule add to 64.226.71.55 table 100 priority 200
ip rule add to 137.220.42.146 table 100 priority 200
ip rule add to 34.117.59.81 table 100 priority 200
ip route flush table 100
ip route add default dev wg0 table 100
ip route flush cache
ip rule add fwmark 2 lookup main priority 20

ip route flush table 100
ip rule flush table 100
ip rule del from 10.0.0.0/24 table main priority 100

node /root/expriments/wireguard/client/submitv.js
node /root/expriments/wireguard/client/submitv_b.js
curl https://ipinfo.io/json

ping 45.32.29.7