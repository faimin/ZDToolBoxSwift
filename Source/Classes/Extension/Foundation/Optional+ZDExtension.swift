//
//  Optional+ZDExtension.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/18.
//

import Foundation

// MARK: - Optional Extension

// https://www.objc.io/blog/2019/01/22/non-empty-optionals/
extension Optional where Wrapped: Collection {
    var nonEmpty: Wrapped? {
        return self?.isEmpty == true ? nil : self
    }
}

extension Collection {
    var noEmpty: Self? {
        return isEmpty ? nil : self
    }
}
