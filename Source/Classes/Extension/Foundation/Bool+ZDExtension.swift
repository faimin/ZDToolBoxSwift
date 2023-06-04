//
//  Bool+ZDExtension.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

/// Int -> Bool
extension Bool: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value != 0)
    }
}

