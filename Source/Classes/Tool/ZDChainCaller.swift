//
//  ZDChainCaller.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//
//  链式调用

#if canImport(Foundation)
    import Foundation

    extension NSObject: ZDSChainProtocol {}
#endif

@dynamicMemberLookup
public struct ZDChainCaller<T> {
    private let base: T

    public init(_ base: T) {
        self.base = base
    }

    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> T {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return object
        }
    }

    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> ZDChainCaller<T> {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return Self(object)
        }
    }
}

public protocol ZDSChainProtocol {
    associatedtype T

    var chain: ZDChainCaller<T> { get set }
}

public extension ZDSChainProtocol {
    var chain: ZDChainCaller<Self> {
        get { ZDChainCaller(self) }
        set {}
    }
}
