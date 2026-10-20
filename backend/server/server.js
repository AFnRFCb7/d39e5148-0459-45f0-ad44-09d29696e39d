const bcrypt = require("bcrypt");
const express = require("express") ;
const fs = require("fs") ;
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
const output = process.env.OUTPUT
    ? fs.createWriteStream(process.env.OUTPUT)
    : process.stdout;
app.get
    (
        "/api/health-check/admin/marker" ,
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
app.post("/api/login", async (request, response) => {
    console.log("0577672097034619");
    const { email, password } = request.body;

    if (!email || !password) {
        return response.status(400).send("Missing email or password");
    }

    try {
        const result = await database.query(
            "SELECT id, email, password_hash, admin FROM users WHERE email = $1",
            [email]
        );
        console.log(`Login attempt: ${JSON.stringify({
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
