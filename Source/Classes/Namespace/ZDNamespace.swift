//
//  ZDNamespace.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import Foundation

// MARK: - ZDSWrapper

public struct ZDSWrapper<T> {
    // MARK: Properties

    /// Base object to extend.
    public internal(set) var base: T

    // MARK: Lifecycle

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: T) {
        self.base = base
    }
}

// MARK: - ZDSAny

public protocol ZDSAny {
    associatedtype ZDSType

    /// Type
    static var zd: ZDSWrapper<ZDSType>.Type { get set }

    /// Instance
    var zd: ZDSWrapper<ZDSType> { mutating get set }
}

public extension ZDSAny {
    static var zd: ZDSWrapper<Self>.Type {
        get {
            return ZDSWrapper<Self>.self
        }
        set {}
    }

    var zd: ZDSWrapper<Self> {
        get {
            ZDSWrapper(self)
        }
        set {}
    }
}

// MARK: - ZDSGenericWrapper

public struct ZDSGenericWrapper<T, T1> {
    // MARK: Properties

    /// Base object to extend.
    public internal(set) var base: T

    // MARK: Lifecycle

    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: T) {
        self.base = base
    }
}

// MARK: - ZDSGenericAny

public protocol ZDSGenericAny {
    associatedtype T1
}

public extension ZDSGenericAny {
    /// Gets a namespace holder for compatible types.
    var zd: ZDSGenericWrapper<Self, T1> {
        get { return ZDSGenericWrapper(self) }
        set {}
    }

    /// Gets a namespace holder for compatible meta types.
    static var zd: ZDSGenericWrapper<Self, T1>.Type {
        get { return ZDSGenericWrapper<Self, T1>.self }
        set {}
    }
}

// MARK: - NSObject + ZDSAny

/// Extend NSObject with `zd` proxy.
extension NSObject: ZDSAny {}
