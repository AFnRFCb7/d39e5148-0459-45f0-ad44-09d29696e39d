const { defineConfig , test , expect } = require("@playwright/test");
const gatewayDomain = process.env.GATEWAY_DOMAIN ?? "visa-staging.com" ;
const backendHost = process.env.BACKEND_HOST ?? "localhost";
const backendPort = process.env.BACKEND_PORT ?? "14636";
const backendUrl = `http://${ backendHost }:${ backendPort }/api` ;
test.describe("Admin Frontend" , () => {
});
test.describe("Gateway Server", ( ) => {
    test.describe("Admin Server", ( ) => {
        test.describe("Unauthenticated User", ( ) => {
            test.describe("Health Check", () => {
                test.describe("Unauthenticated Buttons", ( ) => {
                    test("GET, SET, GET, restore marker", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
                test.describe("Regular Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /regular/i,
                        });
                        const getButton = row.getByRole("button", {
                            name: "GET",
                        });
                        const setButton = row.getByRole("button", {
                            name: "SET",
                        });
                        const markerInput = page.getByRole("textbox", {
                            name: /marker/i,
                        });
                        const getResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/regular/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const getResponse = await getResponsePromise;
                        expect(getResponse.status()).toBe(401);
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
                test.describe("Admin Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /admin/i,
                        });
                        const getButton = row.getByRole("button", {
                            name: "GET",
                        });
                        const setButton = row.getByRole("button", {
                            name: "SET",
                        });
                        const markerInput = page.getByRole("textbox", {
                            name: /marker/i,
                        });
                        const getResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/admin/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const getResponse = await getResponsePromise;
                        expect(getResponse.status()).toBe(401);
                        await markerInput.fill(changedMarker);
                        const setResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/admin/marker")
                            && response.request().method() === "PUT"
                        );
                        await setButton.click();
                        const setResponse = await setResponsePromise;
                        expect(setResponse.status()).toBe(401);
                        const verifyResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/admin/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const verifyResponse = await verifyResponsePromise;
                        expect(verifyResponse.status()).toBe(401);
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
            });
            test.describe("Utility", () => {
                test("not admin", async ({ page }) => {
                    await page.goto("http://127.0.0.1/admin/");
                    await page.getByRole("link", {
                        name: "Login"
                    }).click();
                    await page.getByRole("button", {
                        name: "Logout"
                    }).click();
                    await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    await page.getByRole("link", {
                        name: "Home"
                    }).click();
                    await page.getByRole("link", {
                        name: "Utility",
                    }).click();
                    await page.getByLabel(/^password$/i).fill(
                        "1425855021653621"
                    );
                    await page.getByLabel(/^admin$/i).selectOption("false");
                    await page.getByRole("button", {
                        name: "Generate Hash"
                    }).click();
                    await expect(
                        page.locator("p").filter({ hasText: /Not logged in/i })
                    ).toBeVisible();
                    await page.getByRole("link", {
                        name: "Home"
                    }).click();
                    await page.getByRole("link", {
                        name: "Login"
                    }).click();
                    await page.getByRole("button", {
                        name: "Logout"
                    }).click();
                    await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                });
            });
        }) ;
        test.describe("Regular User", ( ) => {
            test.describe("Health Check", () => {
                test.describe("Unauthenticated Buttons", ( ) => {
                    test("GET, SET, GET, restore marker", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("textbox", {
                            name: /email/i
                        }).fill("playwright-regular@example.com");
                        await page.getByLabel(/password/i).fill(
                            "playwright"
                        );
                        await page.getByRole("button", {
                            name: "Login"
                        }).click();
                        await expect(page.getByText(/<LOGGED IN> playwright-regular@example.com false/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
                test.describe("Regular Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("textbox", {
                            name: /email/i
                        }).fill("playwright-regular@example.com");
                        await page.getByLabel(/password/i).fill(
                            "playwright"
                        );
                        await page.getByRole("button", {
                            name: "Login"
                        }).click();
                        await expect(page.getByText(/<LOGGED IN> playwright-regular@example.com false/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const originalMarker = "4066203055180760";
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /regular/i,
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
                test.describe("Admin Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("textbox", {
                            name: /email/i
                        }).fill("playwright-regular@example.com");
                        await page.getByLabel(/password/i).fill(
                            "playwright"
                        );
                        await page.getByRole("button", {
                            name: "Login"
                        }).click();
                        await expect(page.getByText(/<LOGGED IN> playwright-regular@example.com false/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const originalMarker = "4066203055180760";
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /admin/i,
                        });
                        const getButton = row.getByRole("button", {
                            name: "GET",
                        });
                        const setButton = row.getByRole("button", {
                            name: "SET",
                        });
                        const markerInput = page.getByRole("textbox", {
                            name: /marker/i,
                        });
                        const getResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/admin/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const getResponse = await getResponsePromise;
                        expect(getResponse.status()).toBe(401);
                        await markerInput.fill(changedMarker);
                        const setResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/admin/marker")
                            && response.request().method() === "PUT"
                        );
                        await setButton.click();
                        const setResponse = await setResponsePromise;
                        expect(setResponse.status()).toBe(401);
                        const verifyResponsePromise = page.waitForResponse(response =>
                            response.url().includes("/api/health-check/admin/marker")
                            && response.request().method() === "GET"
                        );
                        await getButton.click();
                        const verifyResponse = await verifyResponsePromise;
                        expect(verifyResponse.status()).toBe(401);
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
            });
            test.describe("Utility", () => {
                test("not admin", async ({ page }) => {
                    await page.goto("http://127.0.0.1/admin/");
                    await page.getByRole("link", {
                        name: "Login"
                    }).click();
                    await page.getByRole("textbox", {
                        name: /email/i
                    }).fill("playwright-regular@example.com");
                    await page.getByLabel(/password/i).fill(
                        "playwright"
                    );
                    await page.getByRole("button", {
                        name: "Login"
                    }).click();
                    await expect(page.getByText(/<LOGGED IN> playwright-regular@example.com false/)).toBeVisible();
                    await page.getByRole("link", {
                        name: "Home"
                    }).click();
                    await page.getByRole("link", {
                        name: "Utility",
                    }).click();
                    await page.getByLabel(/^password$/i).fill(
                        "1425855021653621"
                    );
                    await page.getByLabel(/^admin$/i).selectOption("false");
                    await page.getByRole("button", {
                        name: "Generate Hash"
                    }).click();
                    await expect(
                        page.locator("p").filter({ hasText: /Not logged in/i })
                    ).toBeVisible();
                    await page.getByRole("link", {
                        name: "Home"
                    }).click();
                    await page.getByRole("link", {
                        name: "Login"
                    }).click();
                    await page.getByRole("button", {
                        name: "Logout"
                    }).click();
                    await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                });
            });
        }) ;
        test.describe("Admin User", ( ) => {
            test.describe("Health Check", () => {
                test.describe("Unauthenticated Buttons", ( ) => {
                    test("GET, SET, GET, restore marker", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("textbox", {
                            name: /email/i
                        }).fill("playwright-admin@example.com");
                        await page.getByLabel(/password/i).fill(
                            "playwright"
                        );
                        await page.getByRole("button", {
                            name: "Login"
                        }).click();
                        await expect(page.getByText(/<LOGGED IN> playwright-admin@example.com true/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
                test.describe("Regular Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("textbox", {
                            name: /email/i
                        }).fill("playwright-admin@example.com");
                        await page.getByLabel(/password/i).fill(
                            "playwright"
                        );
                        await page.getByRole("button", {
                            name: "Login"
                        }).click();
                        await expect(page.getByText(/<LOGGED IN> playwright-admin@example.com true/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const originalMarker = "4066203055180760";
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /regular/i,
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
                    });
                });
                test.describe("Admin Buttons", () => {
                    test("GET and SET rejected when unauthenticated", async ({ page }) => {
                        await page.goto("http://127.0.0.1/admin/");
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("textbox", {
                            name: /email/i
                        }).fill("playwright-admin@example.com");
                        await page.getByLabel(/password/i).fill(
                            "playwright"
                        );
                        await page.getByRole("button", {
                            name: "Login"
                        }).click();
                        await expect(page.getByText(/<LOGGED IN> playwright-admin@example.com true/)).toBeVisible();
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Health Check",
                        }).click();
                        const originalMarker = "4066203055180760";
                        const changedMarker = "8752749554083637";
                        const row = page.getByRole("row", {
                            name: /admin/i,
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
                        await page.getByRole("link", {
                            name: "Home"
                        }).click();
                        await page.getByRole("link", {
                            name: "Login"
                        }).click();
                        await page.getByRole("button", {
                            name: "Logout"
                        }).click();
                        await expect(page.getByText(/<NOT LOGGED IN>/)).toBeVisible();
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
            expect(response?.status()).toBe(401);
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

        expect(response?.status()).toBe(401);
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

        expect(response?.status()).toBe(401);
    });
});
test.describe("Web Frontend", () => {
}) ;