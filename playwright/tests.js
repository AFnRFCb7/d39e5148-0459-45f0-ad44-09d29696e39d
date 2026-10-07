const { chromium, firefox } = require("playwright");

const browserName = process.env.BROWSER ?? "chromium";
const headless = process.env.HEADLESS !== "false";

const browsers = {
  chromium: {
    type: chromium,
    executablePath: "/mounts/chromium/bin/chromium"
  },
  firefox: {
    type: firefox,
    executablePath: "/mounts/firefox/bin/firefox"
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

  await page.goto("http://localhost:14636/hello?name=me");

  console.log(await page.title());

  if (!headless) {
    await page.waitForTimeout(60000);
  }

  await browser.close();
})();