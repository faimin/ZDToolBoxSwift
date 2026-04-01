//
//  ZDChainCaller.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//
//  Chain-style API

#if canImport(Foundation)
import Foundation

extension NSObject: ZDSChainProtocol {}
#endif

// MARK: - ZDChainCaller

@dynamicMemberLookup
public struct ZDChainCaller<T> {
    // MARK: Properties

    private let base: T

    // MARK: Lifecycle

    /// Creates a chain wrapper for a base value.
    ///
    /// - Parameter base: Base value to mutate through dynamic members.
    ///
    /// Example:
    /// ```swift
    /// let label = UILabel().chain.text("Hi")
    /// ```
    public init(_ base: T) {
        self.base = base
    }

    // MARK: Functions

    /// Returns a closure that sets a writable key path and returns the modified base value.
    ///
    /// - Parameter keyPath: Writable key path on the base value.
    /// - Returns: Setter closure.
    ///
    /// Example:
    /// ```swift
    /// let value: UILabel = UILabel().chain.text("Hello")
    /// ```
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> T {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return object
        }
    }

    /// Returns a closure that sets a writable key path and returns the next chain wrapper.
    ///
    /// - Parameter keyPath: Writable key path on the base value.
    /// - Returns: Setter closure that keeps chain style.
    ///
    /// Example:
    /// ```swift
    /// let label = UILabel()
    ///     .chain
    ///     .text("Hello")
    ///     .textAlignment(.center)
    /// ```
    public subscript<Value>(dynamicMember keyPath: WritableKeyPath<T, Value>) -> (Value) -> ZDChainCaller<T> {
        { value in
            var object = base
            object[keyPath: keyPath] = value
            return Self(object)
        }
    }
}

// MARK: - ZDSChainProtocol

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
