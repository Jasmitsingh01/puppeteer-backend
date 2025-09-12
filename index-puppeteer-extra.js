const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');
const fs = require('fs');
const http = require('http');

// Use stealth plugin
puppeteer.use(StealthPlugin());

(async () => {
    const browser = await puppeteer.launch({
        headless: false,
        args: ['--no-sandbox','--start-maximized', '--remote-debugging-port=9223', 
            '--remote-debugging-address=0.0.0.0','--disable-setuid-sandbox'],      
      });

  const browserWSEndpoint = browser.wsEndpoint();
  fs.writeFileSync('wsEndpoint.txt', browserWSEndpoint);

  http.get('http://localhost:9223/json/version', res => {
    let data = '';
    res.on('data', chunk => (data += chunk));
    res.on('end', () => {
      const { webSocketDebuggerUrl } = JSON.parse(data);
      fs.writeFileSync('wsEndpoint.txt', webSocketDebuggerUrl);
      console.log(`Remote debugging endpoint: ${webSocketDebuggerUrl}`);
    });
  });
 })();