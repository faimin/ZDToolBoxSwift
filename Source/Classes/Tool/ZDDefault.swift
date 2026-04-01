//
//  ZDDefault.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/2/6.
//

import Foundation

// MARK: - ZDDefaultValue

public protocol ZDDefaultValue {
    associatedtype DFValue: Codable

    static var defaultValue: DFValue { get }
}

#if swift(>=5.1)
/// Provides default values for properties via property wrappers.
///
/// [Property wrappers introduction](https://swiftgg.gitbook.io/swift/swift-jiao-cheng/10_properties#property-wrappers)
///
/// ## example:
///
///     class Example {
///         @Default<Int.Empty> var a: Int
///         @Default<String.Empty>("hello world") var text: String
///         @Default<Empty> var emptyString: String
///         @Default<Empty> var emptyArray: [String]
///     }
///
@propertyWrapper
public struct ZDDefault<T: ZDDefaultValue> {
    // MARK: Properties

    /// Wrapped value with fallback default support.
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable {
    ///     @ZDDefault<String.Empty> var name: String
    /// }
    /// ```
    public var wrappedValue: T.DFValue

    // MARK: Lifecycle

    /// Creates the wrapper using `T.defaultValue`.
    public init() {
        wrappedValue = T.defaultValue
    }

    /// Creates the wrapper with an explicit wrapped value.
    ///
    /// - Parameter wrappedValue: Initial wrapped value.
    public init(wrappedValue: T.DFValue) {
        self.wrappedValue = wrappedValue
    }
}

extension ZDDefault: Codable {
    /// Decodes wrapped value and falls back to `T.defaultValue` when value is missing/invalid.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            wrappedValue = T.defaultValue
        } else {
            wrappedValue = (try? container.decode(T.DFValue.self)) ?? T.defaultValue
        }
    }
}

extension ZDDefault: Equatable where T.DFValue: Equatable {}

public extension KeyedDecodingContainer {
    /// Decodes a `ZDDefault` property wrapper, returning default value when key is absent.
    ///
    /// - Parameters:
    ///   - type: Wrapper type.
    ///   - key: Coding key.
    /// - Returns: Decoded wrapper instance.
    ///
    /// Example:
    /// ```swift
    /// struct User: Codable {
    ///     @ZDDefault<String.Empty> var name: String
    /// }
    /// ```
    func decode<T>(
        _ type: ZDDefault<T>.Type,
        forKey key: Key
    ) throws -> ZDDefault<T> where T: ZDDefaultValue {
        (try? decodeIfPresent(type, forKey: key)) ?? ZDDefault(wrappedValue: T.defaultValue)
    }
}
#endif

public extension Bool {
    enum False: ZDDefaultValue {
        public static let defaultValue = false
    }

    enum True: ZDDefaultValue {
        public static let defaultValue = true
    }
}

// MARK: - String.Empty

/// Default value is `""`.
public extension String {
    /// Empty "".count = 0
    enum Empty: ZDDefaultValue {
        public static let defaultValue = ""
    }
}

// MARK: - Int.Empty

/// Default value is `0`.
public extension Int {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0
    }
}

// MARK: - Double.Empty

/// Default value is `0.0`.
public extension Double {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0.0
    }
}

// MARK: - Float.Empty

/// Default value is `0.0`.
public extension Float {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0.0
    }
}

// MARK: - CGFloat.Empty

/// Default value is `0.0`.
public extension CGFloat {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0.0
    }
}

// MARK: - Array.Empty

/// Default value is an empty array.
public extension Array {
    enum Empty: ZDDefaultValue where Element: Codable, Element: Equatable {
        public static var defaultValue: [Element] {
            [Element]()
        }
    }
}

// MARK: - Dictionary.Empty

/// Default value is an empty dictionary.
public extension Dictionary {
    enum Empty<K, V>: ZDDefaultValue where K: Codable & Hashable, V: Codable & Equatable {
        public static var defaultValue: [K: V] {
            [K: V]()
        }
    }
}

// MARK: - Empty

/// Empty collection default value, e.g. `String`, `Array`, etc.
public enum Empty<T>: ZDDefaultValue where T: Codable, T: Equatable, T: RangeReplaceableCollection {
    public static var defaultValue: T {
        T()
    }
}
