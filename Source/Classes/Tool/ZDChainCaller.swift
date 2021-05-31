//
//  ZDChainCaller.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/5/31.
//
//  链式调用

import Foundation


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
    
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> Self<T> {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return Self(object)
        }
    }
}

public protocol ZDSChainProtocol {
    associatedtype T
    var zd: ZDChainCaller<T> { get set }
}

extension ZDSChainProtocol {
    public var zd: ZDChainCaller<Self> {
        get { ZDChainCaller(self) }
        set {}
    }
}

extension NSObject: ZDSChainProtocol {}

