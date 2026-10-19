const express = require("express") ;
const fs = require("fs") ;
const util = require("util");
const cors = require("cors") ;
const app = express() ;
app.use(cors()) ;
app.use(express.json());



const port = Number(process.argv[2]) ;
const name = process.argv[3] ;

import session from "express-session";

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

const { Pool } = require("pg");
const database = new Pool({
    host: "127.0.0.1",
    port: 11187,
    database: "postgres",
    user: "postgres"
});
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

import bcrypt from "bcrypt";

app.post("/api/login", async (request, response, next) => {
    try {
        const { email, password } = request.body ?? {};

        if (
            typeof email !== "string" ||
            typeof password !== "string" ||
            !email.trim() ||
            !password
        ) {
            return response.status(400).json({
                error: "Email and password are required"
            });
        }

        const result = await pool.query(
            `SELECT id, email, password_hash, admin
             FROM users
             WHERE email = $1`,
            [email.trim()]
        );

        const row = result.rows[0];

        if (
            !row ||
            !(await bcrypt.compare(password, row.password_hash))
        ) {
            return response.status(401).json({
                error: "Invalid email or password"
            });
        }

        request.session.regenerate((error) => {
            if (error) {
                return next(error);
            }

            request.session.user = {
                id: row.id,
                email: row.email,
                admin: row.admin
            };

            request.session.save((error) => {
                if (error) {
                    return next(error);
                }

                return response.json({
                    user: request.session.user
                });
            });
        });
    } catch (error) {
        next(error);
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
