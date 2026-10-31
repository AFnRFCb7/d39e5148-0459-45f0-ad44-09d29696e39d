import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://127.0.0.1:8080/www/');
  await page.getByRole('link', { name: 'Log In' }).click();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await page.getByRole('textbox', { name: 'email' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'email' }).press('Tab');
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.getByLabel('Language').selectOption('zh-CN');
  await page.getByRole('button', { name: '退出登录' }).click();
  await page.getByRole('link', { name: 'Log In' }).click();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await page.getByRole('textbox', { name: 'email' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'email' }).press('Tab');
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.goto('http://127.0.0.1:8080/www/');
});