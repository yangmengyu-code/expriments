const { chromium } = require('playwright');
const os = require("os");
const fs = require("fs");
const NIC = "enp1s0";
const url = "https://qqwllkmn.qzz.io/baseline/autosubmit/?reqmode=p1";
const port = 1081;
const username = "root";
const password = "m123456";
// 全局忽略任何异常避免退出
process.on('uncaughtException', err => {
  console.log("IGNORED:", err.message);
});
process.on('unhandledRejection', err => {
  console.log("IGNORED:", err.message);
});
const Timeout = 5000;
const Turns = 1;

const nets = os.networkInterfaces();
const iface = nets[NIC];
if (!iface) {
    console.error(`Network interface ${NIC} not found`);
    process.exit(1);
}

const ipv4 = iface.find(i => i.family === "IPv4")?.address;

if (!ipv4) {
    console.error(`IPv4 not found on ${NIC}`);
    process.exit(1);
}

console.log("IPv4 address on enp1s0:",ipv4);

const all_ips = fs.readFileSync("/root/expriments/ips.txt", "utf-8").split("\n").map(ip => ip.trim()).filter(ip => ip);
console.log("IP Count:", all_ips.length, "\nIPs:\n", all_ips.join("\n"));
const ips = all_ips.filter(ip => ip !== ipv4);
console.log("New IP Count:", ips.length, "\nNew IPs:\n", ips.join("\n"));

async function BrowserRequest(url, ip) {
  const browser = await chromium.launch({
    headless: true,
    args: ['--no-sandbox'],
    proxy: {
        server: `http://${ip}:${port}`,
        username: username,
        password: password
    }
  });

  const page = await browser.newPage();

  // 捕获所有 console 输出（不退出）
  page.on('console', async msg => {
    try {
      const text = msg.text();
      console.log("Browser:", text);
    } catch {}
  });

  // 页面错误也忽略
  page.on('pageerror', err => {
    console.log("PageError IGNORED:", err.message);
  });

  // 网络错误也忽略
  page.on('requestfailed', req => {
    console.log("RequestFailed IGNORED:", req.url());
  });

  // 1) 强制等待页面加载完成
  try {
    await page.goto(url, {
      timeout: 0,
      waitUntil: "load"   // 必须等到 load
    });
  } catch (e) {
    console.log("Goto IGNORED:", e.message);
  }

  // 2) 等待页面内 JS 有机会执行
  await page.waitForTimeout(Timeout);

  // 3) 执行你的脚本
  try {
    await page.evaluate(() => {
      console.log("JS running!");
    });
  } catch {}

  // 4) 再等几秒确保 console 都输出
  await page.waitForTimeout(Timeout);

  await browser.close();
}

async function start() {
  let turn = 1;
  while (turn <= Turns) {
    let count = 1;
    for (const ip of ips) {
      console.log("\n\n\n");
      console.log("================================");
      console.log("Turn:", turn, "Proxy IP:", ip, "Baseline HTTP Proxy Request Count:", count);
      await BrowserRequest(url, ip);
      console.log("================================");
      count++;
    }
    turn++;
  }
}

start();