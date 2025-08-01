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

    subscript(index: Int) -> Character? {
        guard !base.isEmpty, index >= 0, index < base.count else {
            return nil
        }
        return base[base.index(base.startIndex, offsetBy: index)]
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
    func substring(maxLength: Int, addEllipsis: Bool) -> String {
        guard !base.isEmpty else {
            return base
        }

        let length = base.count
        guard length > maxLength else {
            return base
        }

        var maxEnd = Int.max
        var tempMaxLength = maxLength
        var range: Range<T.Index> = base.startIndex ..< base.startIndex
        while maxEnd > maxLength {
            tempMaxLength -= 1
            range = base.rangeOfComposedCharacterSequence(at: base.index(base.startIndex, offsetBy: tempMaxLength))
            maxEnd = base.distance(from: range.lowerBound, to: range.upperBound)
        }
        guard !range.isEmpty, maxEnd != Int.max, length <= maxEnd else {
            return base
        }
        let subStr = String(base[range]) + (addEllipsis ? "..." : "")
        return subStr
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
