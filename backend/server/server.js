const bcrypt = require("bcrypt");
const express = require("express") ;
const fs = require("fs") ;
const path = require("path") ;
const util = require("util");
const cors = require("cors") ;
const session = require("express-session");
const app = express() ;
app.use(cors()) ;
app.use(express.json());
const port = Number(process.argv[2]) ;
const name = process.argv[3] ;
const { Pool } = require("pg");
const database = new Pool({
    host: "127.0.0.1",
    port: 11187,
    database: "postgres",
    user: "postgres"
});
app.use(session({
    name: "visa.sid",
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    cookie: {
        httpOnly: true,
        sameSite: "lax",
        secure: process.env.NODE_ENV === "production"
    }
}));
function requireAdmin(request, response, next) {
    if (!request.session.user) {
        return response.status(401).json({
            error: "Not logged in"
        });
    }else if (! request.session.user.admin) {
        return response.status(401).json({
            error: "Not admin"
        })
    }
    next();
}
function requireLogin(request, response, next) {
    if (!request.session.user) {
        return response.status(401).json({
            error: "Not logged in"
        });
    }

    next();
}
const output = process.env.OUTPUT
    ? fs.createWriteStream(process.env.OUTPUT)
    : process.stdout;
app.get("/api/auth/linked-providers", async (request, response) => {
    const user = request.session.user;

    if (!user) {
        return response.status(401).json({
            error: "Not logged in"
        });
    }

    try {
        const result = await database.query(
            `SELECT provider
             FROM user_auth_providers
             WHERE user_id = $1
             ORDER BY provider`,
            [user.id]
        );

        const linkedProviders = new Set(
            result.rows.map(row => row.provider)
        );

        response.json({
            providers: [
                {
                    provider: "password",
                    linked: true
                },
                {
                    provider: "google",
                    linked: linkedProviders.has("google")
                }
            ]
        });
    } catch (error) {
        output.write(util.inspect(error) + "\n");
        response.status(500).json({
            error: "Internal server error"
        });
    }
});
app.post("/api/auth/password/login", async (request, response) => {
    const { email, password } = request.body;

    if (!email || !password) {
        return response.status(400).send("Missing email or password");
    }

    try {
        const result = await database.query(
            "SELECT id, email, password_hash, admin FROM users WHERE email = $1",
            [email]
        );
        output.write(`Login attempt: ${JSON.stringify({
            email,
            userCount: result.rows.length
        })}\n`);
        if (result.rows.length === 0) {
            return response.status(401).send("Invalid credentials");
        }
        const user = result.rows[0];
        const valid = await bcrypt.compare(password, user.password_hash);
        if (!valid) {
            return response.status(401).send("Invalid credentials");
        }
        request.session.user = {
            id: user.id,
            email: user.email,
            admin: user.admin
        };
        response.send("login");
    } catch (error) {
        output.write(util.inspect(error) + "\n");
        response.status(500).send("Internal server error");
    }
});
app.post("/api/auth/logout", (request, response, next) => {
    request.session.destroy(error => {
        if (error) {
            return next(error);
        }

        response.clearCookie("visa.sid");
        response.sendStatus(204);
    });
});
app.get
    (
        "/api/auth/providers" ,
        async ( request , response ) => response.sendFile("/mounts/package/data/auth.json")
    ) ;
app.get
    (
        "/api/data/fonts/:fontname" ,
        async ( request , response ) =>
        {
            const fontname = request.params.fontname;
            response.sendFile(`/mounts/package/data/fonts/${ fontname }` ) ;
        }
    ) ;
app.get(
    "/api/data/images/:filename",
    async ( request , response ) =>
        {
            const filename = request.params.filename;
            if ( ! /^[a-zA-Z0-9_-]+\.(jpg|jpeg|png|webp|svg)$/i.test(filename) )
                {
                    return response.sendStatus(400);
                }
            response.sendFile(`/mounts/package/images/${ filename }` ) ;
        }
) ;
app.get(
    "/api/data/i18n/:locale",
    async (request, response) => {
        const locale = request.params.locale
        if (!["en-US", "zh-CN"].includes(locale)) {
            return response.sendStatus(404)
        }
        response.sendFile(
            path.join("/mounts", "package", "data", "i18n", `${locale}.json`),
            (error) => {
                if (error && !response.headersSent) {
                    console.error(error)
                    response.sendStatus(error.statusCode || 500)
                }
            }
        )
    }
)
app.get
    (
        "/api/health-check/admin/marker" ,
        requireAdmin,
        async ( request , response ) =>
            {
                const result = await database.query(
                    "SELECT marker FROM \"health-check\" LIMIT 1"
                ) ;
                response.json(result.rows[0].marker) ;
            }
    ) ;
app.put
    (
        "/api/health-check/admin/marker",
        requireAdmin,
        async (request, response) =>
            {
                const result = await database.query(
                    'UPDATE "health-check" SET marker = $1 RETURNING marker',
                    [request.body.marker]
                )
                response.json(result.rows[0].marker)
            }
    ) ;
app.get
    (
        "/api/health-check/regular/marker" ,
        requireLogin,
        async ( request , response ) =>
            {
                const result = await database.query(
                    "SELECT marker FROM \"health-check\" LIMIT 1"
                ) ;
                response.json(result.rows[0].marker) ;
            }
    ) ;
app.put
    (
        "/api/health-check/regular/marker",
        requireLogin,
        async (request, response) =>
            {
                const result = await database.query(
                    'UPDATE "health-check" SET marker = $1 RETURNING marker',
                    [request.body.marker]
                )
                response.json(result.rows[0].marker)
            }
    ) ;
app.get
    (
        "/api/health-check/unauthenticated/marker" ,
        async ( request , response ) =>
            {
                const result = await database.query(
                    "SELECT marker FROM \"health-check\" LIMIT 1"
                ) ;
                response.json(result.rows[0].marker) ;
            }
    ) ;
app.put
    (
        "/api/health-check/unauthenticated/marker",
        async (request, response) =>
            {
                const result = await database.query(
                    'UPDATE "health-check" SET marker = $1 RETURNING marker',
                    [request.body.marker]
                )
                response.json(result.rows[0].marker)
            }
    ) ;
app.get("/api/session", (request, response) => {
    response.json({
        loggedIn: !!request.session.user,
        user: request.session.user || null
    });
});
app.put("/api/user/locale", requiresLogin, async (request, response) => {
    const user = request.session.user;

    if (!user) {
        return response.status(401).send("Not logged in");
    }

    const { locale } = request.body;

    if (!["en-US", "zh-CN"].includes(locale)) {
        return response.status(400).send("Unsupported locale");
    }

    try {
        await database.query(
            "UPDATE users SET locale = $1 WHERE id = $2",
            [locale, user.id]
        );

        response.send("locale updated");
    } catch (error) {
        output.write(util.inspect(error) + "\n");
        response.status(500).send("Internal server error");
    }
});
app.get
    (
        "/api/utility/password",
        requireAdmin,
        async (request, response) => {
            const { password } = request.query;
            if (typeof password !== "string" || password.length === 0) {
                return response.status(400).send("Missing password");
            }
            try {
                response.type("text/plain").send(hash);
            } catch (error) {
                output.write(util.inspect(error) + "\n");
                response.status(500).send("Internal server error");
            }
        });
app.post("/api/consultation", (request, response) => {
    response.send("consultation") ;
}) ;
app.listen
    (
        port ,
        () =>
            {
                output.write(`listening on port ${ port }`) ;
            }
    ) ;
