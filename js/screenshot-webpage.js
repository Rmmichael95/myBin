#!/usr/bin/env node

const { chromium } = require('playwright');

const url = process.argv[2];
const output = process.argv[3] || 'screenshot.png';

if (!url) {
  console.error('Usage: pw-screenshot <url> [output.png]');
  process.exit(1);
}

(async () => {
  const browser = await chromium.launch();
  const page = await browser.newPage({
    viewport: { width: 1920, height: 1080 }
  });

  console.log(`→ Loading: ${url}`);

  await page.goto(url, { waitUntil: 'domcontentloaded' });

  // 🔑 Scroll to trigger lazy loading
  await page.evaluate(async () => {
    await new Promise((resolve) => {
      let lastHeight = 0;
      let sameCount = 0;

      const timer = setInterval(() => {
        window.scrollTo(0, document.body.scrollHeight);

        const newHeight = document.body.scrollHeight;

        if (newHeight === lastHeight) {
          sameCount++;
        } else {
          sameCount = 0;
        }

        lastHeight = newHeight;

        if (sameCount >= 3) {
          clearInterval(timer);
          resolve();
        }
      }, 400);
    });
  });

  // scroll back to top for clean capture
  await page.evaluate(() => window.scrollTo(0, 0));

  // small buffer for animations/images
  await page.waitForTimeout(2000);

  console.log(`→ Taking full-page screenshot`);

  await page.screenshot({
    path: output,
    fullPage: true
  });

  await browser.close();

  console.log(`✔ Saved: ${output}`);
})();
