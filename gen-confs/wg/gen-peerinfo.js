const fs = require("fs");
const path = require("path");

const baseDir = __dirname;

const ipsFile = path.join(baseDir, "ips.txt");
const keysFile = path.join(baseDir, "keys.txt");
const outFile = path.join(baseDir, "peerinfo.json");

// 读取IP
const ips = fs.readFileSync(ipsFile, "utf8")
    .split("\n")
    .map(v => v.trim())
    .filter(Boolean);

// 读取keys
const keys = fs.readFileSync(keysFile, "utf8")
    .split("\n")
    .map(v => v.trim())
    .filter(Boolean)
    .map(line => {
        const [priv, pub] = line.split(/\s+/);
        return { privatekey: priv, publickey: pub };
    });

if (ips.length > keys.length) {
    console.error(`keys.txt 行数不足: ${keys.length} < ${ips.length}`);
    process.exit(1);
}

const peers = ips.map((ip, i) => ({
    id: i,
    public_IP: ip,
    local_IP: `10.0.0.${i + 1}`,
    privatekey: keys[i].privatekey,
    publickey: keys[i].publickey
}));

fs.writeFileSync(outFile, JSON.stringify(peers, null, 4));

console.log(`Generated ${outFile}`);