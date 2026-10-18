const express = require("express") ;
const fs = require("fs") ;
const util = require("util");
const cors = require("cors") ;
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
app.post("/api/login", (request, response) => {
    response.send("login") ;
}) ;
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
