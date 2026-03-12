source /root/clashctl/scripts/cmd/clashctl.sh
clashon
clashtun on
Count=$(grep -cve '^[[:space:]]*$' /root/expriments/ips.txt) - 1
for i in $(seq 1 $((Count))); do
    clashsub use $i
    printf "\n\n\n================================"
    printf "Using sub %s" "$i"
    printf "================================"
    node /root/expriments/ss_proxy/client/submitp.js
    node /root/expriments/ss_proxy/client/submitp_b.js
done
clashoff
clashtun off