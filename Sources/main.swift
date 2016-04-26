import Kitura
import KituraNet
import KituraSys
import MongoDB
import SwiftyJSON
import Foundation

let router = Router()
let db = Database(client: try Client(host: "mongo", port: 27017), name: "db")

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
