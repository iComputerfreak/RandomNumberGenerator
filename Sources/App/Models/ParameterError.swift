// Copyright © 2025 Jonas Frey. All rights reserved.

import Foundation

enum ParameterError: Swift.Error {
    case invalidRange(min: Int, max: Int)
    case invalidLength(length: Int)
    case missingRange
}
