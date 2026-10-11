const { chromium } = require("playwright");

const browserName = process.env.BROWSER ?? "chromium";
const headless = process.env.HEADLESS !== "false";

const browsers = {
  chromium: {
    type: chromium,
    executablePath: "/mounts/chromium/bin/chromium"
  }
};

(async () => {
  const config = browsers[browserName];

  if (!config) {
    throw new Error(`Unknown browser: ${browserName}`);
  }

  const browser = await config.type.launch({
    executablePath: config.executablePath,
    headless
  });

  const page = await browser.newPage();

  const response = await page.goto(
    "http://localhost:14636/health-check/unauthenticated/marker"
  );

  if (!response || response.status() !== 400) {
    throw new Error(
      `Expected HTTP 200, got ${response?.status() ?? "no response"}`
    );
  }

  console.log(await page.title());

  if (!headless) {
    console.log(`Waiting 10 seconds before closing ${browserName}...`);
    await page.waitForTimeout(10000);
  }

  await browser.close();
})();