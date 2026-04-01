//
//  ZDSwiftFunction.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/23.
//

import Foundation

/// https://twitter.com/johnsundell/status/1055562781070684162
///
/// Creates a zero-argument closure by binding a value to a one-argument closure.
///
/// - Parameters:
///   - value: Captured value.
///   - closure: Transform closure that consumes `value`.
/// - Returns: A closure with signature `() -> B`.
///
/// Example:
/// ```swift
/// let log = combine("hello") { value in
///     "value: \(value)"
/// }
/// print(log()) // value: hello
/// ```
public func combine<A, B>(_ value: A, with closure: @escaping (A) -> B) -> () -> B {
    return { closure(value) } // <==> { () in closure(value) }
}
