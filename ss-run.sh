source /root/clashctl/scripts/cmd/clashctl.sh
clashon
clashtun on
Count=10
for i in $(seq 0 $((Count-1))); do
    clashsub use $i
    printf "\n\n\n================================"
    printf "Using sub %s" "$i"
    printf "================================"
    node /root/expriments/ss_proxy/client/submitp.js
    node /root/expriments/ss_proxy/client/submitp_b.js
done
clashoff
clashtun off