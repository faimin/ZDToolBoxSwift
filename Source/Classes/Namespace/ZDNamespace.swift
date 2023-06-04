//
//  ZD.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import Foundation

public struct ZDSWraper<T> {
    /// Base object to extend.
    public var base: T

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: T) {
        self.base = base
    }
}

public protocol ZDSAny {
    
    associatedtype ZDSType
    
    /// 类变量
    static var zd: ZDSWraper<ZDSType>.Type { get set }
    
    /// 实例变量
    var zd: ZDSWraper<ZDSType> { get set }
}

extension ZDSAny {
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
extension NSObject: ZDSAny {}
