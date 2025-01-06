// Copyright © 2025 Jonas Frey. All rights reserved.

import Vapor

struct RandomIntQuery: Content {
    let min: Int?
    let max: Int?
    let length: Int?

    var isValid: Bool {
        (min != nil && max != nil) || length != nil
    }
}
