//
//  Int+ZDExtension.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/5/31.
//


/// Bool -> Int
extension Int: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value ? 1 : 0)
    }
}
