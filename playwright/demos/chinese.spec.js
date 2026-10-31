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
  await announce('Login as the Chinese User');
  await page.getByRole('link', { name: 'Log In' }).click();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'email' }).press('Tab');
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await announce('Logged in as the Chinese User.  Switch to Chinese Language.');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.getByLabel('Language').selectOption('zh-CN');
  await announce('The Chinese Language Should Be Persisted To The Chinese User.  Now Log Out');
  await page.getByRole('button', { name: '退出登录' }).click();
  await announce('Log in again as the Chinese User.  We should see chinese.');
  await page.getByRole('link', { name: 'Log In' }).click();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'email' }).press('Tab');
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await page.getByRole('button', { name: 'Log in' }).click();
});