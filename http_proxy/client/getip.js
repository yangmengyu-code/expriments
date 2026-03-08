const fs = require('fs');
const os = require('os');
const path = require('path');

let list = [];
/**
 * 获取本机所有 IPv4 地址
 */
function getLocalIPs() {
    const interfaces = os.networkInterfaces();
    const localIPs = new Set(['127.0.0.1', 'localhost', '::1']);

    for (const devName in interfaces) {
        interfaces[devName].forEach(details => {
            if (details.family === 'IPv4') {
                localIPs.add(details.address);
            }
        });
    }
    return localIPs;
}

function generateProxyList(inputPath) {
    try {
        const localIPs = getLocalIPs();
        
        // 1. 读取文件并按行分割（兼容 Windows \r\n 和 Linux \n）
        const data = fs.readFileSync(inputPath, 'utf8');
        const lines = data.split(/\r?\n/);

        // 2. 过滤掉：空行、纯空格行、以及包含本机 IP 的行
        const filteredList = lines
            .map(line => line.trim())
            .filter(line => {
                if (!line) return false; // 排除空行
                
                // 检查该行是否包含任何一个本机 IP
                // 考虑到格式可能是 "IP:Port"，这里用 includes 或正则判断
                const isLocal = Array.from(localIPs).some(ip => line.includes(ip));
                return !isLocal;
            });

        // 3. 将过滤后的列表追加到全局 list 中
        list.push(...filteredList);
        console.log(`✅ 处理完成！`);
        console.log(`原数据: ${lines.length} 行`);
        console.log(`IPs: ${lines.join(', ')}`);
        console.log(`过滤后: ${list.length} 行`);
        console.log(`IPs: ${list.join(', ')}`);
    } catch (err) {
        console.error('❌ 处理出错:', err.message);
    }
}

// 执行
const input = path.join(__dirname, '/root/expriments/http_proxy/proxylist.txt');
generateProxyList(input);
module.exports = {
    list: list,
    version: '1.0.0'
};