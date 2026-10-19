import express from "express";
import fs from "node:fs";
import util from "node:util";
import cors from "cors";
import session from "express-session";
import bcrypt from "bcrypt";
import { Pool } from "pg";

const app = express();

app.use(cors());
app.use(express.json());

const port = Number(process.argv[2]);
const name = process.argv[3];

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

const database = new Pool({
    host: "127.0.0.1",
    port: 11187,
    database: "postgres",
    user: "postgres"
});