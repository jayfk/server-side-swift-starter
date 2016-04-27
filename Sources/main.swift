/**
 * This example uses IBMs Kitura framework: https://github.com/IBM-Swift/Kitura
 * For more examples, see: https://github.com/IBM-Swift/Kitura-Sample/blob/master/Sources/KituraSample/main.swift
 *
 * You can replace this code and use whatever framework you like (or code your own!).
 * Just make sure your code starts some kind of server and speaks HTTP on port 8090.
**/
import Kitura
import KituraNet
import KituraSys
import MongoDB
import SwiftyJSON
import Foundation

// initializes connection to the mongo database, see https://github.com/Danappelxx/SwiftMongoDB
// for usage information
let db = Database(client: try Client(host: "mongo", port: 27017), name: "db")

let router = Router()

// Endpoint for /, returns plain old html
router.get("/") { request, response, next in
    response.setHeader("Content-Type", value: "text/html; charset=utf-8")
    let p1 = request.params["user"] ?? "(nil)"
    do {
        try response.status(HttpStatusCode.OK).send(
            "<h1>Hi from swift</h1> <img src='/static/static.gif'/></br>" +
            "<a href='/about'>Give me some JSON</a>").end()
    } catch {
        print("Failed to send response \(error)")
    }
}

// Endpoint for /about, returns JSON
router.get("/about") {
request, response, next in
    let json = JSON([
        "hi": "from swift",
        "db": JSON([
            "vendor": "mongo db",
        ]),
        "static": JSON([
            "directory": "static/",
            "test-image": "/static/static.gif"
        ]),
        "admin": JSON([
            "interface": "/admin/",
            "credentials": "env/admin.env"
        ])
        ]
    )
    response.status(HttpStatusCode.OK).sendJson(json)
    next()
}

let server = HttpServer.listen(8090, delegate: router)
Server.run()
