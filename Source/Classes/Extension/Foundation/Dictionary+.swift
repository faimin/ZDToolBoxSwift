//
//  Dictionary+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension ZDSWrapper where T == [AnyHashable: Any] {
    /// Merges key-value pairs from another sequence into the dictionary.
    ///
    /// - Parameter other: Sequence of `(key, value)` pairs.
    ///
    /// Example:
    /// ```swift
    /// var payload: [AnyHashable: Any] = ["id": 1]
    /// payload.zd.merge(["name": "Zero"])
    /// ```
    mutating func merge<S>(_ other: S)
        where S: Sequence, S.Iterator.Element == (key: T.Key, value: T.Value) {
        for (key, value) in other {
            base[key] = value
        }
    }
}
