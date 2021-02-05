//
//  ZD.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import Foundation

public struct ZDSWraper<Base: AnyObject> {
    /// Base object to extend.
    public let base: Base

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ZDObject: AnyObject {
    
    associatedtype ZDObjectType: AnyObject
    
    /// 类变量
    static var zd: ZDSWraper<ZDObjectType>.Type { get set }
    
    /// 实例变量
    var zd: ZDSWraper<ZDObjectType> { get set }
}

extension ZDObject {
    public static var zd: ZDSWraper<Self>.Type {
        get {
            return ZDSWraper<Self>.self
        }
        set { }
    }
    
    public var zd: ZDSWraper<Self> {
        get {
            return ZDSWraper(self)
        }
        set { }
    }
}

/// Extend NSObject with `zd` proxy.
extension NSObject: ZDObject {}
