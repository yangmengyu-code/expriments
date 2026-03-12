#!/bin/bash
set -euo pipefail
source /root/clashctl/scripts/cmd/clashctl.sh
clashoff
clashtun off

NIC="enp1s0"
PEERINFO_FILE="/root/expriments/wireguard/confs/peerinfo.json"
TARGETS=("45.32.29.7" "45.77.13.64" "64.226.71.55" "137.220.42.146")
TARGETS_STR=$(printf "%s/32," "${TARGETS[@]}")
TARGETS_STR=${TARGETS_STR%,}  # 去掉最后一个逗号

# 获取本机 IPv4
IP=$(ip -4 addr show $NIC | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

if [[ -z "$IP" ]]; then
    echo "IPv4 not found on $NIC"
    exit 1
fi
echo "IPv4 address on $NIC: $IP"

# 读取 peerinfo.json 查找本机 peer
if ! command -v jq &> /dev/null; then
    echo "jq is required for parsing JSON"
    exit 1
fi

SELF_PEER=$(jq -r --arg ip "$IP" '.[] | select(.public_IP==$ip)' "$PEERINFO_FILE")
if [[ -z "$SELF_PEER" ]]; then
    echo "Public IP not found in peerinfo.json"
    exit 1
fi

# 配置临时路由表 table 100
for tgt in "${TARGETS[@]}"; do
    ip rule add to "$tgt" table 100 priority 200 || true
done
ip route flush table 100 || true
ip route add default dev wg0 table 100 || true
ip route flush cache

# 遍历 peers
NUM_PEERS=$(jq length "$PEERINFO_FILE")
for ((i=0;i<NUM_PEERS;i++)); do
    PEER_IP=$(jq -r ".[$i].public_IP" "$PEERINFO_FILE")
    PEER_KEY=$(jq -r ".[$i].publickey" "$PEERINFO_FILE")
    PEER_LOCAL=$(jq -r ".[$i].local_IP" "$PEERINFO_FILE")

    if [[ "$PEER_IP" != "$IP" ]]; then
        wg set wg0 peer "$PEER_KEY" allowed-ips "$PEER_LOCAL/32,$TARGETS_STR"
        printf "\n\n\n================================\n"
        printf "WireGuard Peer %s\n" "$PEER_IP"
        printf "================================\n"
        node /root/expriments/wireguard/client/submitv.js
        node /root/expriments/wireguard/client/submitv_b.js
        wg set wg0 peer "$PEER_KEY" allowed-ips "$PEER_LOCAL/32"
    fi
done

# 清理路由表和规则
ip route flush table 100 || true
ip rule flush table 100 || true

echo "Done."