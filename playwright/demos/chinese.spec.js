import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('http://127.0.0.1:8080/www/');
  await expect(page.getByRole('link', { name: 'Log In' })).toBeVisible();
  await page.getByRole('link', { name: 'Log In' }).click();
  await expect(page.getByRole('button', { name: 'Email and Password' })).toBeVisible();
  await page.getByRole('button', { name: 'Email and Password' }).click();
  await expect(page.getByRole('textbox', { name: 'email' })).toBeVisible();
  await expect(page.getByRole('textbox', { name: 'password' })).toBeVisible();
  await expect(page.getByRole('button', { name: 'Log in' })).toBeVisible();
  await page.getByRole('textbox', { name: 'email' }).click();
  await page.getByRole('textbox', { name: 'email' }).fill('/home/emory/resources/mounts/0817428816951530/repository/visa/playwright/demos/chinese.spec.js');
  await page.getByRole('textbox', { name: 'email' }).press('ControlOrMeta+z');
  await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
  await page.getByRole('textbox', { name: 'password' }).click();
  await page.getByRole('textbox', { name: 'password' }).fill('playwright');
  await page.getByRole('button', { name: 'Log in' }).click();
  await page.getByText('\' Logged in as playwright-').click();
  await page.getByLabel('Language').click();
  await page.getByLabel('Language').selectOption('zh-CN');
  await expect(page.getByRole('button', { name: '退出登录' })).toBeVisible();
  await page.goto('http://127.0.0.1:8080/www/');
});