clear
cd
cd expriments
git fetch --all
git reset --hard origin/main
find . -name "*.sh" -exec chmod +x {} +
clashsub add /root/expriments/temp1.yaml
clashsub add /root/expriments/temp2.yaml