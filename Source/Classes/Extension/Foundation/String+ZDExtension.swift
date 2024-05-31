//
//  String+ZDExtension.swift
//  ZDToolBoxSwift
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
    
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript(bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript(bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript(bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript(bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript(bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
   }
}
