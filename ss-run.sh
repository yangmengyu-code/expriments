#!/bin/bash
source /root/clashctl/scripts/cmd/clashctl.sh
clashoff
clashtun off
# ================= 配置参数 =================
NIC="enp1s0"
ROUND_INTERVAL=25
# 初始时间 (所有机器需一致)
INITIAL_TIME="2026-03-13T14:22:00+08:00"
COUNT=1
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

# ================= 2. 主逻辑循环 =================
# 将初始时间转换为 Unix 时间戳
LAST_START_TIME=$(date -d "$INITIAL_TIME" +%s)
TURN=1

for (( count=1; count<=$COUNT; count++ )); do
    while (( TURN <= N )); do
        NOW=$(date +%s)

        if (( NOW >= LAST_START_TIME )); then
            echo -e "\n============= Turn $COUNT ============="

            if (( TURN == MY_ID )); then
                # 接收逻辑
                echo "RECEIVE from other peers."
                clashoff
                clashtun off
                sleep $(( ROUND_INTERVAL - 2 ))
            else
                # 发送逻辑
                TARGET_IP=${IPS[$((TURN - 1))]}
                echo "SEND to Peer: $TARGET_IP, Peer ID: $TURN"
                
                # 执行命令
                clashon
                clashtun on
                clashsub use "$TURN"
                node /root/expriments/ss_proxy/client/submitp.js
                node /root/expriments/ss_proxy/client/submitp_b.js
                clashoff
                clashtun off
            fi

            # 更新下一次开始时间戳，增加 Turn
            LAST_START_TIME=$(( LAST_START_TIME + ROUND_INTERVAL ))
            (( TURN++ ))
        fi

        # 每秒检查一次，防止 CPU 空转
        sleep 1
    done
done

echo "All rounds completed"
exit 0