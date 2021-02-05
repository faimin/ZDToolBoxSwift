//
//  URLExtention.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/11/18.
//

import Foundation

// MARK: - URL Extension

/// example: `let url: URL = "www.google.com"`
extension URL: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self = URL(string: value)!
    }
}
