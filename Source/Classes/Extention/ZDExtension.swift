//
//  ZDExtension.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import Foundation

public protocol ZDBase {
    associatedtype MMExtensionBase
    
    var zd: ZDExtension<MMExtensionBase> { get set }
}

public struct ZDExtension<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}
