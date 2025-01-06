// Copyright © 2025 Jonas Frey. All rights reserved.

import Vapor

struct Payload: Content {
    let min: Int?
    let max: Int?
    let result: Int?
    let error: String?
    
    init(from query: RandomIntQuery) {
        self.min = query.min ?? query.length.map(Self.minValue(for:))
        self.max = query.max ?? query.length.map(Self.maxValue(for:))
        do {
            self.result = try Self.calculateResult(from: query)
            self.error = nil
        } catch ParameterError.invalidRange(min: _, max: _) {
            self.error = "Invalid Range. Please make sure your lower bound is <= your upper bound."
            self.result = nil
        } catch ParameterError.invalidLength(length: _) {
            self.error = "Invalid length. Please specify a length of at least 1."
            self.result = nil
        } catch ParameterError.missingRange {
            self.error = "Missing Range. Use the min and max query parameters or the length parameter to specify a range."
            self.result = nil
        } catch {
            self.error = "Error"
            self.result = nil
        }
    }

    private static func calculateResult(from query: RandomIntQuery) throws -> Int {
        // If we have a length, it needs to be at least 1
        if let length = query.length {
            guard length >= 1 else { throw ParameterError.invalidLength(length: length) }
        }

        // If min/max is missing, use the length
        let min = query.min ?? query.length.map(minValue(for:))
        let max = query.max ?? query.length.map(maxValue(for:))

        guard let min, let max else { throw ParameterError.missingRange }

        guard min <= max else {
            throw ParameterError.invalidRange(min: min, max: max)
        }
        return Int.random(in: min...max)
    }

    private static func minValue(for length: Int) -> Int {
        // For length == 1, we need to return 0, not the calculated lower bound of 10^0 = 1
        guard length > 1 else { return 0 }
        return Int(pow(10, Double(length) - 1))
    }

    private static func maxValue(for length: Int) -> Int {
        Int(pow(10, Double(length)) - 1)
    }
}
