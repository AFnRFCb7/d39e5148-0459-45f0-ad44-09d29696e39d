const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  outputDir: '/mounts/output',
  testDir: '/mounts/tests',
  testMatch: '**/*.spec.js',

  workers: 1,

  use: {
    headless: process.env.HEADLESS!=="false",
    launchOptions: {
      executablePath: '/mounts/chromium/bin/chromium',
    },
  },
});