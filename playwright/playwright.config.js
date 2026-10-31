const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  outputDir: '/mounts/output',
  testDir: '/mounts/tests',
  testMatch: '**/*.spec.js',

  workers: 1,

  use: {
    headless: false,
    launchOptions: {
      executablePath: '/mounts/chromium/bin/chromium',
    },
  },
});