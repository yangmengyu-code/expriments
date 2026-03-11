apt install nodejs npm -y;
npm install playwright;
npx playwright install;
npx playwright install-deps;

node client/autosubmit/headlessbrowserd.js;

node client/autosubmit/headlessbrowserp.js;

node client/headlessbrowser.js;
node client/headlessbrowserproxy.js