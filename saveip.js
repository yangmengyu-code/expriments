const fs = require('fs');

async function saveIP() {
    try {
        // 1. 发起请求获取 IP
        const response = await fetch('https://verygood.us.kg/ip');
        
        if (!response.ok) {
            throw new Error(`HTTP 错误! 状态码: ${response.status}`);
        }

        const ip = await response.text();

        // 2. 将结果写入 myip.txt (若文件不存在会自动创建)
        fs.writeFileSync('./myip.txt', ip.trim());
        
        console.log(`成功！IP ${ip.trim()} 已保存到 myip.txt`);
    } catch (error) {
        console.error('获取或保存 IP 失败:', error.message);
    }
}

saveIP();