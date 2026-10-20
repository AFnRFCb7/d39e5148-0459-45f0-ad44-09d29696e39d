const { defineConfig , test , expect } = require("@playwright/test");
const gatewayDomain = process.env.GATEWAY_DOMAIN ?? "visa-staging.com" ;
const backendHost = process.env.BACKEND_HOST ?? "localhost";
const backendPort = process.env.BACKEND_PORT ?? "14636";
const backendUrl = `http://${ backendHost }:${ backendPort }/api` ;
test.describe("Admin Frontend" , () => {
});
test.describe("Gateway Server", ( ) => {
    test.describe("Admin Server", ( ) => {
        test.describe("Health Check" , ( ) => {
            test.describe("Unautheticated User", ( ) => {
                test.describe("Unauthenticated Buttons", ( ) => {
                    test("GET, SET, GET, restore marker", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const originalMarker = "4066203055180760";
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /unauthenticated/i,
                        });
                        const markerInput = page.getByRole("textbox", {
                            name: /marker/i,
                        });
                        const getButton = row.getByRole("button", {
                            name: "GET",
                        });
                        const setButton = row.getByRole("button", {
                            name: "SET",
                        });
                        await getButton.click();
                        await expect(row).toContainText(originalMarker);
                        await markerInput.fill(changedMarker);
                        await setButton.click();
                        await expect(row).toContainText(changedMarker);
                        await getButton.click();
                        await expect(row).toContainText(changedMarker);
                        await markerInput.fill(originalMarker);
                        await setButton.click();
                        await expect(row).toContainText(originalMarker);
                        await getButton.click();
                        await expect(row).toContainText(originalMarker);
                    });
                });
                test.describe("Regular Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const row = page.getByRole("row", {
                            name: /regular/i,
                        });
                        const getButton = row.getByRole("button", {
                            name: "GET",
                        });
                        const setButton = row.getByRole("button", {
                            name: "SET",
                        });
                        const originalMarker = "4066203055180760";
                        const changedMarker = "8752749554083637";
                        const getResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/regular/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const getResponse = await getResponsePromise;
                        expect(getResponse.status()).toBe(401);
                        const markerInput = page.getByRole("textbox", {
                            name: /marker/i,
                        });
                        await markerInput.fill(changedMarker);
                        const setResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/regular/marker")
                            && response.request().method() === "PUT"
                        );
                        await setButton.click();
                        const setResponse = await setResponsePromise;
                        expect(setResponse.status()).toBe(401);
                        const verifyResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/regular/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const verifyResponse = await verifyResponsePromise;
                        expect(verifyResponse.status()).toBe(401);
                    });
                });
            }) ;
        }) ;
    });
    test.describe("Backend Server", ( ) => {
        test("admin marker health check", async ({ page }) => {
            const response = await page.goto(
                `http://127.0.0.1/api/health-check/admin/marker` ,
                {
                    headers: {
                        Host: gatewayDomain,
                    },
                }
            )
            expect(response?.status()).toBe(200);
        });
        test("unauthenticated marker health check", async ({ page }) => {
            const response = await page.goto(
                `http://127.0.0.1/api/health-check/unauthenticated/marker`,
                {
                    headers: {
                        Host: gatewayDomain,
                    },
                }
            );
            expect(response?.status()).toBe(200);
        });
        test("regular marker health check", async ({ page }) => {
            const response = await page.goto(
                `http://127.0.0.1/api/health-check/regular/marker` ,
                {
                    headers: {
                        Host: gatewayDomain,
                    },
                }
            );
            expect(response?.status()).toBe(401);
        });
    });
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