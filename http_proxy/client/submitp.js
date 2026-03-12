const { chromium } = require('playwright');
const { ips } = require('./getip.js');
const url = "https://qqwllkmn.qzz.io/autosubmit/?reqmode=p1";
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
    for (const ip of ips) {
      console.log("\n\n\n");
      console.log("================================");
      console.log("Proxy IP:", ip, "HTTP Proxy Request Count:", count);
      await BrowserRequest(url, ip);
      console.log("================================");
    }
    turn++;
  }
}

start();