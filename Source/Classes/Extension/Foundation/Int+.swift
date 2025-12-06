//
//  Int+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension ZDSWrapper where T == IntegerLiteralType {
    var toBool: Bool {
        base != 0
    }

    var toStr: String {
        "\(base)"
    }
}
