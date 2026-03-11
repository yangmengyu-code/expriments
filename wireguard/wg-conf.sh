
wg-quick down wg0
wg-quick up wg0
ip rule add from 10.0.0.0/24 table main priority 100
ip rule add to 45.32.29.7 table 100 priority 200
ip rule add to 45.77.13.64 table 100 priority 200
ip rule add to 64.226.71.55 table 100 priority 200
ip rule add to 137.220.42.146 table 100 priority 200

ip route flush table 100
ip route add default dev wg0 table 100
ip route flush cache

ping 45.32.29.7

ip route flush cache

wg-quick down wg0
ip route flush table 100
ip rule flush table 100
ip rule del from 10.0.0.0/24 table main priority 100

ip rule
ip route
ip route show table 100
ip route show table 100

ip route flush table 100
ip route add default dev enp1s0 table 100
ip route flush cache