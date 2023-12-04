import Vapor

enum ParameterError: Swift.Error {
    case invalidRange(min: Int, max: Int)
}

struct RandomIntQuery: Content {
    let min: Int
    let max: Int
    var result: Int {
        get throws {
            guard min <= max else {
                throw ParameterError.invalidRange(min: min, max: max)
            }
            return Int.random(in: min...max)
        }
    }
}

func routes(_ app: Application) throws {
    app.get { (req) async throws -> View in
        let query = try req.query.decode(RandomIntQuery.self)
        req.logger.info("Generating a random integer between \(query.min) and \(query.max)")
        return try await req.view.render("index", ["min": query.min, "max": query.max, "result": query.result])
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
