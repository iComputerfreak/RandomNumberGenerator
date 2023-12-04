import Vapor

enum ParameterError: Swift.Error {
    case invalidQuery(String)
}

struct RandomIntQuery: Content {
    let min: Int
    let max: Int
    var result: Int {
        Int.random(in: min...max)
    }
}

func routes(_ app: Application) throws {
    app.get { (req) async throws -> View in
        let query = try req.query.decode(RandomIntQuery.self)
        return try await req.view.render("index", ["min": query.min, "max": query.max, "result": query.result])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
