const { chromium } = require("playwright");

(async () => {
  const browser = await chromium.launch({
    executablePath: "/mounts/chromium/bin/chromium" ,
    headless : false
  });

  const page = await browser.newPage();

  await page.goto("http://localhost:14636/hello?name=me");
  console.log(await page.title());
  await new Promise(resolve => setTimeout(resolve, 5000));
  await browser.close();
})();