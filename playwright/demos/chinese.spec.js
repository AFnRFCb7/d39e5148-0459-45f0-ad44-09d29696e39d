import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
    await page.goto('http://127.0.0.1:8080/www/');
    await expect(page.getByRole('link', { name: 'Log In' })).toBeVisible({timeout: 10000});
    await page.getByRole('link', { name: 'Log In' }).click();
    await expect(page.getByRole('button', { name: 'Email and Password' })).toBeVisible({timeout: 10000});
    await page.getByRole('button', { name: 'Email and Password' }).click();
    await expect(page.getByRole('textbox', { name: 'email' })).toBeVisible({timeout: 10000});
    await expect(page.getByRole('textbox', { name: 'password' })).toBeVisible({timeout: 10000});
    await expect(page.getByRole('button', { name: 'Log in' })).toBeVisible({timeout: 10000});
    await page.getByRole('textbox', { name: 'email' }).click();
    await page.getByRole('textbox', { name: 'email' }).fill('playwright-chinese@example.com');
    await page.getByRole('textbox', { name: 'email' }).press('Tab');
    await page.getByRole('textbox', { name: 'password' }).fill('playwright');
    await page.getByRole('button', { name: 'Log in' }).click();
    await expect(page.getByLabel('Language')).toBeVisible({ timeout: 100000});
    await page.getByLabel('Language').selectOption('zh-CN');
const language = page.getByLabel('Language');

await language.selectOption('zh-CN');

console.log('Selected value:', await language.inputValue());
console.log('Selected option:', await language.locator('option:checked').textContent());
    await expect(page.getByRole('button', { name: '退出登录' })).toBeVisible({ timeout: 10000 });
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