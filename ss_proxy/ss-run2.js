const fs = require("fs");
const os = require("os");
const { execSync } = require('child_process');

const ROUND_INTERVAL = 15 * 1000; // 15 seconds per round

// 初始时间（所有机器需一致）
const InitialTime = "2026-03-14T00:00:00+08:00";

let Turn = 1;
let lastStartTime = new Date(InitialTime);

// 读取IP列表
function loadIPs() {
    let txt = fs.readFileSync("ips.txt", "utf8");

    return txt
        .split("\n")
        .map(l => l.trim())
        .filter(l => l.length > 0);
}

function run(cmd) {
    console.log('RUN:', cmd);
    try {
        execSync(cmd, { stdio: 'inherit' });
    } catch (e) {
        console.error('Command failed:', cmd);
    }
}
// 获取本机IP
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

const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));


// 主逻辑
async function main() {

    const ips = loadIPs();
    const n = ips.length;

    const index = ips.indexOf(IP);

    if (index === -1) {
        console.error("IP not found in ips.txt:", IP);
        process.exit(1);
    }

    const myId = index + 1;

    console.log("My IP:", IP);
    console.log("My ID:", myId);
    console.log("Total nodes:", n);

    while (Turn <= n) {
        let now = new Date();

        if (now >= lastStartTime) {
            console.log("\n============= Turn", Turn, "=============");
            if (Turn === myId) {
                // 只接收
                console.log("RECEIVE from other peers.");
                await sleep(ROUND_INTERVAL - 2000); // 等待其他节点发送数据
            } else {
                // 发送
                let targetIP = ips[Turn - 1];
                    console.log("SEND to Peer:", targetIP);
                    run(`clashon`);
                    run(`clashtun on`);
                    run(`clashsub use ${Turn}`);
                    run(`node /root/expriments/ss_proxy/client/submitp.js`);
                    run(`node /root/expriments/ss_proxy/client/submitp_b.js`);
                    run(`clashoff`);
                    run(`clashtun off`);
                }
            

            // 更新下一次开始时间
            lastStartTime = new Date(lastStartTime.getTime() + ROUND_INTERVAL);
            Turn++;
        }

        // 适当休眠，防止 CPU 空转（比如每秒检查一次）
        await sleep(1000);
    }

    console.log("All rounds completed");
    process.exit(0);
}

await main();