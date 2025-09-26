const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
const fs = require('fs');
const http = require('http');

// Use stealth plugin
puppeteer.use(StealthPlugin());

(async () => {
    const browser = await puppeteer.launch({
        headless: false,
        args: [
            '--no-sandbox',
            '--remote-debugging-port=9222',
            '--remote-allow-origins=*',
            '--remote-debugging-address=0.0.0.0',
       
        ],  
     
      });

  const browserWSEndpoint = browser.wsEndpoint();
  fs.writeFileSync('wsEndpoint.txt', browserWSEndpoint);

  http.get('http://localhost:9222/json/version', res => {
    let data = '';
    res.on('data', chunk => (data += chunk));
    res.on('end', () => {
      const { webSocketDebuggerUrl } = JSON.parse(data);
      fs.writeFileSync('wsEndpoint.txt', webSocketDebuggerUrl);
      console.log(`Remote debugging endpoint: ${webSocketDebuggerUrl}`);
    });
  });
 })();