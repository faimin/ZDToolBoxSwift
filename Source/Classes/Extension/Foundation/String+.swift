//
//  String+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2022/5/28.
//

import Foundation

public extension ZDSWraper where T == String {
    subscript<R>(range: R) -> T.SubSequence where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min ..< Int.max)
        guard let firstIndex = base.index(base.startIndex, offsetBy: range.lowerBound, limitedBy: base.endIndex),
              let secondIndex = base.index(base.startIndex, offsetBy: range.upperBound, limitedBy: base.endIndex)
        else {
            return ""
        }
        return base[firstIndex ..< secondIndex]
    }

    subscript(i: Int) -> Character {
        return base[base.index(base.startIndex, offsetBy: i)]
    }

    subscript(bounds: CountableRange<Int>) -> Substring {
        let start = base.index(base.startIndex, offsetBy: bounds.lowerBound)
        let end = base.index(base.startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return base[start ..< end]
    }

    subscript(bounds: CountableClosedRange<Int>) -> Substring {
        let start = base.index(base.startIndex, offsetBy: bounds.lowerBound)
        let end = base.index(base.startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return base[start ... end]
    }

    subscript(bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = base.index(base.startIndex, offsetBy: bounds.lowerBound)
        let end = base.index(base.endIndex, offsetBy: -1)
        if end < start { return "" }
        return base[start ... end]
    }

    subscript(bounds: PartialRangeThrough<Int>) -> Substring {
        let end = base.index(base.startIndex, offsetBy: bounds.upperBound)
        if end < base.startIndex { return "" }
        return base[base.startIndex ... end]
    }

    subscript(bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = base.index(base.startIndex, offsetBy: bounds.upperBound)
        if end < base.startIndex { return "" }
        return base[base.startIndex ..< end]
    }
}

public extension ZDSWraper where T == String {
    /// urlComponents
    var urlComponents: URLComponents {
        var components = URLComponents(string: base) ?? URLComponents()

        let fragment = components.fragment
        guard let fragment, !fragment.isEmpty else {
            return components
        }

        let fragmentComponents = fragment.components(separatedBy: "?")
        guard fragmentComponents.count > 1 else {
            return components
        }

        let queryStr = fragmentComponents.last ?? ""
        let tempUrlComponents = URLComponents(string: "https://zd.com?\(queryStr)")

        components.fragment = fragmentComponents.first
        components.query = queryStr
        components.queryItems = tempUrlComponents?.queryItems

        return components
    }
}
