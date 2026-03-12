const fs = require("fs/promises");
const path = require("path");


const baseDir = __dirname;
const ipFile = path.join(__dirname, "ips.txt");

const CONCURRENCY = 50;

const template = (ip) => `mixed-port: 7890
allow-lan: true
bind-address: "*"
mode: rule
log-level: info
external-controller: "127.0.0.1:9090"

proxies:
    - {
          name: "ss",
          type: ss,
          server: ${ip},
          port: 8388,
          cipher: chacha20-ietf-poly1305,
          password: "m123456",
          udp: true,
      }

rules:
    - 'PROCESS-PATH,/usr/local/bin/ssserver,DIRECT'
    - 'PROCESS-PATH,/root/clashctl/bin/mihomo,DIRECT'
    - 'IP-CIDR,45.32.29.7/32,ss'
    - 'IP-CIDR,45.77.13.64/32,ss'
    - 'IP-CIDR,64.226.71.55/32,ss'
    - 'IP-CIDR,137.220.42.146/32,ss'
    - 'MATCH,DIRECT'
`;

async function limit(tasks, limit) {
    const results = [];
    const executing = [];

    for (const task of tasks) {
        const p = task().then(r => {
            executing.splice(executing.indexOf(p), 1);
            return r;
        });

        results.push(p);
        executing.push(p);

        if (executing.length >= limit) {
            await Promise.race(executing);
        }
    }

    return Promise.all(results);
}

async function main() {

    const ips = (await fs.readFile(ipFile, "utf8"))
        .split("\n")
        .map(i => i.trim())
        .filter(Boolean);

    for (const ip of ips) {

        const dir = path.join(baseDir, `conf-${ip}`);

        await fs.rm(dir, { recursive: true, force: true });

        await fs.mkdir(dir, { recursive: true });

        const tasks = [];

        for (const target of ips) {
            if (target === ip) continue;

            tasks.push(async () => {
                const filename = path.join(dir, `proxyto_${target}.yaml`);
                await fs.writeFile(filename, template(target));
            });
        }

        await limit(tasks, CONCURRENCY);

        console.log(`generated ${dir}`);
    }

    console.log("All configs generated.");
}

main();