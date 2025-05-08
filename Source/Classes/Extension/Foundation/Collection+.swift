//
//  Collection+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension ZDSWraper where T: Collection {
    /// get value at index safely
    ///
    /// - Parameter index: The index to include in the range set.
    subscript(index: T.Index) -> T.Element? {
        guard index >= base.startIndex, index < base.endIndex else {
            return nil
        }
        return base[index]
    }

    /// get value at index safely, return default value if failed
    ///
    /// - Parameters:
    ///   - index: The index to include in the range set.
    ///   - default: defaultValue
    subscript(index: T.Index, default: @autoclosure () -> T.Element) -> T.Element {
        // return base.indices.contains(index) ? base[index] : `default`
        guard index >= base.startIndex, index < base.endIndex else {
            return `default`()
        }
        return base[index]
    }
}
