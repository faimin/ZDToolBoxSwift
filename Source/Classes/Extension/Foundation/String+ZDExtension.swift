//
//  String+ZDExtension.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2022/5/28.
//

import Foundation

public extension String {
    
    subscript<T>(zd range: T) -> Self.SubSequence where T: RangeExpression, T.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard let firstIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
              let secondIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
            return ""
        }
        return self[firstIndex..<secondIndex]
    }
}
