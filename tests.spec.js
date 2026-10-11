const { test, expect } = require("@playwright/test");

test.describe("Backend Server", () => {
    test("unauthenticated marker health check", async ({ page }) => {
        const response = await page.goto(
            "http://localhost:14636/health-check/unauthenticated/marker"
        );

        expect(response?.status()).toBe(200);
    });
});