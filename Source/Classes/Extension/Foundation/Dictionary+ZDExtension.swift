//
//  Dictionary+ZDExtension.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension ZDSWraper where T == [AnyHashable: Any] {
    /// 字典合并
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: T.Key, value: T.Value)
    {
        for (key, value) in other {
            base[key] = value
        }
    }
}

public extension Dictionary {
    /// 从字典取值并设置非空的默认值
    subscript(zd key: Key, defaultValue: Value) -> Value {
        return self[key] ?? defaultValue
    }
}
