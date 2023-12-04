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

struct Payload: Content {
    let min: Int
    let max: Int
    let result: Int?
    let error: String?
    
    init(from query: RandomIntQuery) {
        self.min = query.min
        self.max = query.max
        do {
            self.result = try query.result
            self.error = nil
        } catch ParameterError.invalidRange(min: _, max: _) {
            self.error = "Invalid Range"
            self.result = nil
        } catch {
            self.error = "Error"
            self.result = nil
        }
    }
}

func routes(_ app: Application) throws {
    app.get { (req) async throws -> View in
        do {
            let query = try req.query.decode(RandomIntQuery.self)
            req.logger.info("Generating a random integer between \(query.min) and \(query.max)")
            let payload = Payload(from: query)
            return try await req.view.render("index", payload)
        } catch {
            return try await req.view.render("help")
        }
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
