const { chromium } = require("playwright");
const browserName = process.env.BROWSER ?? "chromium";
const headless = process.env.HEADLESS !== "false";
const url = process.env.URL ??
  "http://visa-staging.com/health-check/unauthenticated/marker";

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

  try {
    const context = await browser.newContext({
      extraHTTPHeaders: {
        Host: "visa-staging.com"
      }
    });

    const page = await context.newPage();

    await page.goto(
      "http://127.0.0.1/health-check/unauthenticated/marker"
    );

    console.log(await page.title());
    const page = await browser.newPage();

    const response = await page.goto(url);

    console.log("URL:", url);
    console.log("Status:", response?.status());
    console.log("Title:", await page.title());

    if (!response?.ok()) {
      throw new Error(`Request failed with status ${response?.status()}`);
    }

    if (!headless) {
      console.log(`Waiting 10 seconds before closing ${browserName}...`);
      await page.waitForTimeout(10000);
    }
  } finally {
    await browser.close();
  }
})();