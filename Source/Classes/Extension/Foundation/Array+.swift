//
//  Array+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import Foundation

public extension ZDSWraper where T == [Any] {
    /// 取值，并设置非空的默认值
    subscript(index: Int, defaultValue: T.Element?) -> T.Element? {
        guard index >= 0, base.count > index else {
            return defaultValue
        }
        return base[index]
    }

    /// 取值，并设置非空的默认值
    func objectAtIndex(_ index: Int, defaultValue: T.Element?) -> T.Element? {
        guard index >= 0, base.count > index else {
            return defaultValue
        }
        return base[index]
    }

    /// 安全存值
    mutating func addSafe(_ object: T.Element?) {
        if let obj = object {
            base.append(obj)
        }
    }
}
