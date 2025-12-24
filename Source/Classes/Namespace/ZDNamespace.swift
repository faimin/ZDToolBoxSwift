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

// MARK: - NSObject + ZDSAny

/// Extend NSObject with `zd` proxy.
extension NSObject: ZDSAny {}

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

/// Wrapper for ZDSGeneric2Any types with a generic parameter in a reference way.
public struct ZDSGeneric2Wrapper<T, T1, T2> {
    public internal(set) var base: T
    public init(_ base: T) {
        self.base = base
    }
}

/// Represents a type with a generic parameter.
public protocol ZDSGeneric2Any {
    associatedtype T1
    associatedtype T2
}

public extension ZDSGeneric2Any {
    /// Gets a namespace holder for ZDSGeneric2Any types.
    var zd: ZDSGeneric2Wrapper<Self, T1, T2> {
        get { return ZDSGeneric2Wrapper(self) }
        set {}
    }
    
    /// Gets a namespace holder for ZDSGeneric2Any meta types.
    static var zd: ZDSGeneric2Wrapper<Self, T1, T2>.Type {
        get { return ZDSGeneric2Wrapper<Self, T1, T2>.self }
        set {}
    }
}
