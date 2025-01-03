//
//  Optional+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/18.
//

import Foundation

// MARK: - Optional Extension

// https://www.objc.io/blog/2019/01/22/non-empty-optionals/
public extension Optional where Wrapped: Collection {
    var nonEmpty: Wrapped? {
        return self?.isEmpty == true ? nil : self
    }
    
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var isEmpty: Bool {
        isNilOrEmpty
    }
    
    var isNonEmpty: Bool {
        !isEmpty
    }
}
