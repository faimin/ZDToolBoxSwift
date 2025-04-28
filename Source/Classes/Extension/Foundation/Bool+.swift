//
//  Bool+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension ZDSWraper where T == BooleanLiteralType {
    var toInt: Int {
        base ? 1 : 0
    }
}
