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

// 调度算法
function schedule(i, round, n) {

    let m = (n % 2 === 0) ? n : n + 1;
    let half = m - 1;

    if (round > 2 * half) {
        return { talk: false };
    }

    let phase = Math.floor((round - 1) / half);
    let r = ((round - 1) % half) + 1;

    let peer;

    if (i === m) {
        peer = r;
    } else if (i === r) {
        peer = m;
    }
    else {
        peer = (2 * r - i + m - 1) % (m - 1);
        if (peer === 0) {
            peer = m - 1;
        }
    }
    if (peer > n) {
        return { talk: false };
    }

    let send;

    if (phase === 0) {
        send = i < peer;
    } else {
        send = i > peer;
    }

    return {
        talk: true,
        peer,
        send: send
    };
}


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

    while (Turn < 2 * n - 1) {
        let now = new Date();

        if (now >= lastStartTime) {
            console.log("\n============= Turn", Turn, "=============");

            let decision = schedule(myId, Turn, n);

            if (!decision.talk) {
                console.log("Idle this round");
            } else {
                // 无论是发送还是接收，都需要获取对方的 IP
                let targetIP = ips[decision.peer - 1];
                
                if (decision.send) {
                    console.log("SEND to Peer:", targetIP);
                    run(`clashon`);
                    run(`clashtun on`);
                    run(`clashsub use ${decision.peer}`);
                    run(`node /root/expriments/ss_proxy/client/submitp.js`);
                    run(`node /root/expriments/ss_proxy/client/submitp_b.js`);
                    run(`clashoff`);
                    run(`clashtun off`);
                } else {
                    console.log("RECEIVE from Peer:", targetIP);
                }
            }

            // 更新下一次开始时间，并增加回合数
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