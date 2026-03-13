#!/bin/bash
source /root/clashctl/scripts/cmd/clashctl.sh
# ================= 配置参数 =================
NIC="enp1s0"
ROUND_INTERVAL=15
# 初始时间 (所有机器需一致)
INITIAL_TIME="2026-03-14T00:00:00+08:00"

# ================= 1. 加载数据 =================
if [ ! -f "/root/expriments/ips.txt" ]; then
    echo "Error: ips.txt not found"
    exit 1
fi

# 读取 IP 列表并过滤空行
mapfile -t IPS < <(grep -v '^$' /root/expriments/ips.txt | sed 's/[[:space:]]//g')
N=${#IPS[@]}

# 获取本机 IP
MY_IP=$(ip -4 addr show "$NIC" | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)

if [ -z "$MY_IP" ]; then
    echo "Network interface $NIC or IPv4 not found"
    exit 1
fi

# 获取本机 ID (1-based)
MY_ID=0
for i in "${!IPS[@]}"; do
   if [[ "${IPS[$i]}" == "$MY_IP" ]]; then
       MY_ID=$((i + 1))
       break
   fi
done

if [ "$MY_ID" -eq 0 ]; then
    echo "IP not found in ips.txt: $MY_IP"
    exit 1
fi

echo "My IP: $MY_IP"
echo "My ID: $MY_ID"
echo "Total nodes: $N"

# ================= 2. 调度算法 =================
# 参数: $1=ID, $2=Round, $3=TotalNodes
# 返回格式: talk_bit peer_id send_bit
schedule() {
    local i=$1
    local round=$2
    local n=$3

    local m=$n
    (( n % 2 != 0 )) && m=$((n + 1))
    
    local half=$((m - 1))
    
    # 超过回合数
    if (( round > 2 * half )); then
        echo "0 0 0" # talk=0
        return
    fi

    local phase=$(( (round - 1) / half ))
    local r=$(( (round - 1) % half + 1 ))

    local peer
    if (( i == m )); then
        peer=$r
    elif (( i == r )); then
        peer=$m
    else
        peer=$(( (2 * r - i + m - 1) % (m - 1) ))
        (( peer == 0 )) && peer=$((m - 1))
    fi

    # 虚拟节点检查
    if (( peer > n )); then
        echo "0 0 0"
        return
    fi

    local send=0
    if (( phase == 0 )); then
        (( i < peer )) && send=1
    else
        (( i > peer )) && send=1
    fi

    echo "1 $peer $send" # talk=1, peer=$peer, send=$send
}

# ================= 3. 主循环 =================
LAST_START_TIME=$(date -d "$INITIAL_TIME" +%s)
TURN=1

while (( TURN < 2 * N - 1 )); do
    NOW=$(date +%s)

    if (( NOW >= LAST_START_TIME )); then
        echo -e "\n============= Turn $TURN ============="

        # 读取调度结果到三个变量
        read -r talk peer send < <(schedule "$MY_ID" "$TURN" "$N")

        if (( talk == 0 )); then
            echo "Idle this round"
            sleep $((ROUND_INTERVAL - 2))
        else
            TARGET_IP=${IPS[$((peer - 1))]}
            
            if (( send == 1 )); then
                echo "SEND to Peer: $TARGET_IP"
                clashon
                clashtun on
                clashsub use "$peer"
                node /root/expriments/ss_proxy/client/submitp.js
                node /root/expriments/ss_proxy/client/submitp_b.js
                clashoff
                clashtun off
            else
                echo "RECEIVE from Peer: $TARGET_IP"
            fi
        fi

        # 步进时间并进入下一轮
        LAST_START_TIME=$((LAST_START_TIME + ROUND_INTERVAL))
        ((TURN++))
    fi

    sleep 1
done

echo "All rounds completed"
exit 0