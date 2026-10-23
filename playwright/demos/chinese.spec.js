import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  async function announce(message, pauseMs = 3000) {
    await page.evaluate((message) => {
      let banner = document.getElementById('demo-announcement');
      if (!banner) {
        banner = document.createElement('div');
        banner.id = 'demo-announcement';
        Object.assign(banner.style, {
          position: 'fixed',
          top: '16px',
          left: '50%',
          transform: 'translateX(-50%)',
          zIndex: '999999',
          background: '#202124',
          color: 'white',
          padding: '16px 24px',
          borderRadius: '8px',
          fontSize: '20px',
          boxShadow: '0 4px 12px #0005',
          maxWidth: '80%',
        });
        document.body.appendChild(banner);
      }
      banner.textContent = message;
    }, message);
    await page.evaluate((message) => {
      speechSynthesis.cancel();

      const speech = new SpeechSynthesisUtterance(message);
      speech.lang = 'en-US';
      speech.rate = 1;

      speechSynthesis.speak(speech);
    }, message);
    await page.waitForTimeout(pauseMs);
  }
  await announce('Welcome to the Visa application demo');
  await page.goto('http://127.0.0.1:8080/www/');
  await page.getByRole('link', { name: 'Log In' }).click();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'email' }).press('Tab');
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.getByLabel('Language').selectOption('zh-CN');
  await page.getByRole('button', { name: '退出登录' }).click();
  await page.getByRole('link', { name: 'Log In' }).click();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'email' }).press('Tab');
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.locator('section').filter({ hasText: '您的旅程从这里开始走得更远创造你的未来无论您是出国旅行、留学，还是开启海外新生活，我们都将竭诚为您提供帮助，助您顺利踏上旅程。立即开始' }).click();
  await page.getByText('您的旅程从这里开始走得更远创造你的未来无论您是出国旅行、留学，还是开启海外新生活，我们都将竭诚为您提供帮助，助您顺利踏上旅程。立即开始').click();
});