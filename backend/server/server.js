const express = require("express") ;
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
app.get
    (
        "/health-check/unauthenticated/marker" ,
        async ( request , response ) =>
            {
                const result = await database.query(
                    "SELECT marker FROM \"health-check\" LIMIT 1"
                ) ;
                response.json(response.json(result.rows[0].marker)) ; ;
            }
    ) ;
app.get
    (
        "/hello" ,
        ( request , response ) =>
            {
                const name = request.query.name || "world" ;
                response.send( `hi ${ name }`) ;
            }
    ) ;
app.get
    (
        "/secret" ,
        ( request , response ) =>
            {
                const name = request.query.name || "world" ;
                response.send( `hi ${ name }`) ;
            }
    ) ;
app.post("/login", (request, response) => {
    response.send("login") ;
}) ;
app.post("/consultation", (request, response) => {
    response.send("consultation") ;
}) ;
app.listen
    (
        port ,
        () =>
            {
                console.log(`listening on port ${ port }`) ;
            }
    ) ;
