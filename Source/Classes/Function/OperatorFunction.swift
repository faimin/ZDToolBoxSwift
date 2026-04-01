//
//  OperatorFunction.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/19.
//

import Foundation

// MARK: - Operators

/// http://ios.jobbole.com/92852/
///
/// Postfix increment operator for `Int`.
///
/// - Parameter x: Integer value to increment.
/// - Returns: Previous value before increment.
///
/// Example:
/// ```swift
/// var count = 1
/// let old = count++
/// // old == 1, count == 2
/// ```
@discardableResult
public postfix func ++ (x: inout Int) -> Int {
    defer {
        x += 1
    }
    return x
}

/// Prefix increment operator for `Int`.
///
/// - Parameter x: Integer value to increment.
/// - Returns: New value after increment.
///
/// Example:
/// ```swift
/// var count = 1
/// let new = ++count
/// // new == 2, count == 2
/// ```
@discardableResult
public prefix func ++ (x: inout Int) -> Int {
    x += 1
    return x
}
