const os = require("os");
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

module.exports = {
    ip: ipv4,
};