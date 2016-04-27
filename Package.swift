import PackageDescription

let package = Package(
    name: "#PROJECT_NAME#",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 9),
        .Package(url: "https://github.com/Danappelxx/SwiftMongoDB", majorVersion: 0, minor: 5)
        // add your own dependencies here
    ])