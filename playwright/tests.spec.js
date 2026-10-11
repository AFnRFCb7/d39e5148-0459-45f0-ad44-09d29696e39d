const { defineConfig , test , expect } = require("@playwright/test");
const backendHost = process.env.BACKEND_HOST ?? "localhost";
const backendPort = process.env.BACKEND_PORT ?? "14636";
const backendUrl = `http://${ backendHost }:${ backendPort }` ;
module.exports = defineConfig({
    use: {
        browserName: "chromium",
        headless: true,
        launchOptions: {
            executablePath: "/mounts/chromium/bin/chromium",
        },
    },
});
test.describe("Admin Frontend" , () => {
});
test.describe("Backend Server", () => {
    test("admin marker health check", async ({ page }) => {
        const response = await page.goto(
            `${ backendUrl }/health-check/admin/marker`
        );

        expect(response?.status()).toBe(200);
    });
    test("unauthenticated marker health check", async ({ page }) => {
        const response = await page.goto(
            `${ backendUrl }/health-check/unauthenticated/marker`
        );

        expect(response?.status()).toBe(200);
    });
    test("regular marker health check", async ({ page }) => {
        const response = await page.goto(
            `${ backendUrl }/health-check/regular/marker`
        );

        expect(response?.status()).toBe(200);
    });
});
test.describe("Web Frontend", () => {
}) ;