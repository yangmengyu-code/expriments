find . -name "*.sh" -exec chmod +x {} +

cp ./ips.txt ./gen-confs/clash
cp ./ips.txt ./gen-confs/wg
rm -rf ./gen-confs/clash/confs/*
node ./gen-confs/clash/gen-clashconfs.js
rm -rf ./clash/confs/*
cp -rf ./gen-confs/clash/confs/* ./clash/confs
#  ./gen-confs/wg/gen-keys.sh
node ./gen-confs/wg/gen-peerinfo.js
cp ./gen-confs/wg/peerinfo.json ./wireguard/confs/peerinfo.json
rm -rf ./gen-confs/wg/conf-*
node ./gen-confs/wg/gen-wgconfs.js
rm -rf ./wireguard/confs/conf-*
cp -rf ./gen-confs/wg/conf-* ./wireguard/confs