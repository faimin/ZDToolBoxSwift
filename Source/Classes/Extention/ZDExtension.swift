//
//  ZDExtension.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import Foundation

public struct ZDSWraper<Base> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ZDObject: AnyObject { }

extension ZDObject {
    var zd: ZDSWraper<Self> {
        get {
            return ZDSWraper(self)
        }
        set {
            
        }
    }
    
}
