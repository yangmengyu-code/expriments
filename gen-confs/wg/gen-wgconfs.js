const fs = require("fs");
const path = require("path");

const baseDir = __dirname;
const jsonFile = path.join(baseDir, "peerinfo.json");

const WG_PORT = 51820;
const NIC = "enp1s0";

const peers = JSON.parse(fs.readFileSync(jsonFile, "utf8"));

for (const peer of peers) {
    const dir = path.join(baseDir, `conf-${peer.public_IP}`);

    if (fs.existsSync(dir)) fs.rmSync(dir, { recursive: true, force: true });

    fs.mkdirSync(dir, { recursive: true });
    let conf = `[Interface]
PrivateKey = ${peer.privatekey}
Address = ${peer.local_IP}/24
ListenPort = ${WG_PORT}
FwMark = 51820
Table = off

PostUp   = sysctl -w net.ipv4.ip_forward=1
PostUp   = iptables -A FORWARD -i wg0 -j ACCEPT
PostUp   = iptables -A FORWARD -o wg0 -j ACCEPT
PostUp   = iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o ${NIC} -j MASQUERADE
PostDown = sysctl -w net.ipv4.ip_forward=0
PostDown = iptables -F FORWARD
PostDown = iptables -t nat -F POSTROUTING
`
    for (const other of peers) {
        if (other.id === peer.id) continue;

        conf += `        

[Peer]
PublicKey = ${other.publickey}
AllowedIPs = ${other.local_IP}/32
Endpoint = ${other.public_IP}:${WG_PORT}
PersistentKeepalive = 200`;
    }
    const filename = path.join(dir, `wg0.conf`);
    fs.writeFileSync(filename, conf);
    console.log(`Generated configs for ${peer.public_IP}`);
}

console.log("All WireGuard configs generated.");