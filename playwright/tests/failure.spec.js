test('intentional failure', async ({ page }) => {
  await page.goto('http://127.0.0.1:8080/www/');
  await expect(page.getByRole('heading', { name: 'THIS SHOULD NOT EXIST' })).toBeVisible();
});