import Vapor

func routes(_ app: Application) throws {
    app.get { (req) async throws -> View in
        do {
            let query = try req.query.decode(RandomIntQuery.self)
            guard query.isValid else {
                throw ParameterError.missingRange
            }
            req.logger.info(
                // swiftlint:disable:next line_length
                "Generating a random integer between \(query.min?.description ?? "nil") and \(query.max?.description ?? "nil") with length \(query.length?.description ?? "nil")"
            )
            let payload = Payload(from: query)
            return try await req.view.render("index", payload)
        } catch {
            req.logger.info("Error generating random number: \(error). Showing help page.")
            return try await req.view.render("help")
        }
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}
