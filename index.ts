import puppeteer from 'puppeteer-extra';
import StealthPlugin from 'puppeteer-extra-plugin-stealth';
import fs from 'fs';
import axios from 'axios';

// Use stealth plugin
puppeteer.use(StealthPlugin());

(async () => {
   try {
     console.log('Connecting to existing browser with puppeteer-extra and stealth plugin...');
     
    const { data } = await axios.get('http://localhost:8080/json/version');
    const { webSocketDebuggerUrl } = data;
     
     // Fix the WebSocket URL to use the correct port
     const fixedWebSocketUrl = webSocketDebuggerUrl.replace('ws://localhost/', 'ws://localhost:8080/');
     
     // Connect to the existing browser instance through nginx proxy
     const browser = await puppeteer.connect({
       browserWSEndpoint: fixedWebSocketUrl,
     });

     console.log('Connected to browser successfully!');
     
     // Get existing pages or create a new one
     const pages = await browser.pages();
     let page;
     
     if (pages.length > 0) {
       page = pages[0];
       console.log('Using existing page');
     } else {
       page = await browser.newPage();
       console.log('Created new page');
     }
     
     console.log('Navigating to Facebook.com...');
     
     await page.goto('https://www.youtube.com', { 
       waitUntil: 'networkidle2',
       timeout: 30000
     });
     
     console.log('Successfully navigated to Facebook.com!');
     console.log('Page title:', await page.title());
     
     // Save the browser WebSocket endpoint
     const browserWSEndpoint = browser.wsEndpoint();
     fs.writeFileSync('wsEndpoint.txt', browserWSEndpoint);
     console.log(`WebSocket endpoint saved: ${browserWSEndpoint}`);
     
     console.log('DevTools available at: http://localhost:8080/json/version');
     console.log('Browser is ready for testing Facebook.com!');
     
   } catch (error) {
     console.error('Error occurred:', error);
     console.error('Make sure the Docker container is running with: docker run -d --name puppeteer-backend-nginx -p 8080:8080 ...');
     process.exit(1);
   }
})();
