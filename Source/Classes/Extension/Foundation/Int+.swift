//
//  Int+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension ZDSWraper where T == IntegerLiteralType {
    var toBool: Bool {
        return base != 0
    }
}
