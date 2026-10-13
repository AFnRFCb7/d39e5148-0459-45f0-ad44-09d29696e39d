const { chromium } = require("playwright");

const browserName = process.env.BROWSER ?? "chromium";
const headless = process.env.HEADLESS !== "false";

const url = process.env.URL ??
  "http://127.0.0.1/api/health-check/unauthenticated/marker";

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
const context = await browser.newContext();
const page = await context.newPage();

const response = await page.goto(
  "http://127.0.0.1/api/health-check/unauthenticated/marker",
  {
    headers: {
      Host: "visa-staging.com"
    }
  }
);

console.log("Status:", response?.status());
console.log("URL:", page.url());
console.log("Body:", (await page.locator("body").innerText()).slice(0, 500));
  } finally {
    await browser.close();
  }
})();