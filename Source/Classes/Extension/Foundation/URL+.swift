//
//  URL+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/18.
//

import Foundation

// MARK: - URL Extension

/// example: `let url: URL = "www.google.com"`
extension URL: @retroactive ExpressibleByStringLiteral {
    /// Creates a URL from string literal.
    ///
    /// - Parameter value: URL string.
    ///
    /// Example:
    /// ```swift
    /// let url: URL = "https://www.apple.com"
    /// ```
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
