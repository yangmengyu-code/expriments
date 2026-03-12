const os = require("os");
const fs = require("fs");
const NIC = "enp1s0";
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

// 从/root/ips.txt读取ip(每行一个)，得到ips数组,需要strip掉空行其需要strim掉每行的空白字符
const ips = fs.readFileSync("./ips.txt", "utf-8").split("\n").map(ip => ip.trim()).filter(ip => ip);
console.log("IP Count:", ips.length, "\nIPs:\n", ips.join("\n"));
// 从ips删除ipv4,如果存在,得到new_ips数组
const new_ips = ips.filter(ip => ip !== ipv4);
console.log("New IP Count:", new_ips.length, "\nNew IPs:\n", new_ips.join("\n"));
module.exports = {
    ips: new_ips
};