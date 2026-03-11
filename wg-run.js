#!/usr/bin/env node
const fs = require('fs');
const { execSync } = require('child_process');
const os = require("os");
const NIC = "enp1s0";
const nets = os.networkInterfaces();
const iface = nets[NIC];
if (!iface) {
    console.error(`Network interface ${NIC} not found`);
    process.exit(1);
}

const IP = iface.find(i => i.family === "IPv4")?.address;

if (!IP) {
    console.error(`IPv4 not found on ${NIC}`);
    process.exit(1);
}

console.log("IPv4 address on enp1s0:",IP);

const PEERINFO_FILE = '/root/expriments/wireguard/confs/peerinfo.json';
const TARGETS = [
    '45.32.29.7',
    '45.77.13.64',
    '64.226.71.55',
    '137.220.42.146'
];
const TARGETS_STR = TARGETS.map(ip => `${ip}/32`).join(',');
// 运行命令
function run(cmd) {
    console.log('RUN:', cmd);
    try {
        execSync(cmd, { stdio: 'inherit' });
    } catch (e) {
        console.error('Command failed:', cmd);
    }
}

// 读取 peerinfo
const peers = JSON.parse(fs.readFileSync(PEERINFO_FILE, 'utf8'));

// 找到本机 peer
const selfPeer = peers.find(p => p.public_IP === IP);
if (!selfPeer) {
    console.error('Public IP not found in peerinfo.json');
    process.exit(1);
}

// 配置临时路由 table 100
run('ip rule add from 10.0.0.0/24 table main priority 100');
TARGETS.forEach(ip => {
    run(`ip rule add to ${ip} table 100 priority 200`);
});
run('ip route flush table 100');
run('ip route add default dev wg0 table 100');
run('ip route flush cache');
peers.forEach(peer => {
    if (peer.public_IP !== IP) {
        run(`wg set wg0 peer ${peer.publickey} allowed-ips ${peer.local_IP}/32,${TARGETS_STR}`);
        run(`node /root/expriments/wireguard/client/submitv.js`);
        run(`node /root/expriments/wireguard/client/submitv_b.js`);
        run(`wg set wg0 peer ${peer.publickey} allowed-ips ${peer.local_IP}/32`);
    }
});

run('ip route flush table 100');
run('ip rule flush table 100');
run('ip rule del from 10.0.0.0/24 table main priority 100');

console.log('Done.');