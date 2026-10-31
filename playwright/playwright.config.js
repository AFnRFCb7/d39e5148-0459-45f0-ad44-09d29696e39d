const { defineConfig } = require('@playwright/test');

module.exports = defineConfig({
  testDir: './exams',
  testMatch: '**/*.spec.js',

  workers: 1,

  use: {
    headless: true,
    launchOptions: {
      executablePath: '/mounts/chromium/bin/chromium',
    },
  },
});