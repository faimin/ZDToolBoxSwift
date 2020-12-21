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

public protocol ZDObject: AnyObject {
    
    associatedtype ZDObjectType
    
    /// 类变量
    static var zd: ZDSWraper<ZDObjectType>.Type { get set }
    
    /// 实例变量
    var zd: ZDSWraper<ZDObjectType> { get set }
}

extension ZDObject {
    public var zd: ZDSWraper<Self> {
        get {
            return ZDSWraper(self)
        }
        set { }
    }
    
    public static var zd: ZDSWraper<Self>.Type {
        get {
            return ZDSWraper<Self>.self
        }
        set { }
    }
}

extension NSObject: ZDObject {}
