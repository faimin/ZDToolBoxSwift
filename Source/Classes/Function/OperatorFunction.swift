//
//  OperatorFunction.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/19.
//

import Foundation

// MARK: - 操作符

/// http://ios.jobbole.com/92852/
@discardableResult
public postfix func ++ (x: inout Int) -> Int {
    defer {
        x += 1
    }
    return x
}

@discardableResult
public prefix func ++ (x: inout Int) -> Int {
    x += 1
    return x
}
