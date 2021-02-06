//
//  ZDDefault.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/2/6.
//

import Foundation

public protocol ZDDefaultValue {
    
    associatedtype DFValue: Codable
    
    static var defaultValue: DFValue { get }
}

#if swift(>=5.1)
/// 为属性提供默认值
///
/// [属性包装器介绍](https://swiftgg.gitbook.io/swift/swift-jiao-cheng/10_properties#property-wrappers)
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
    public var wrappedValue: T.DFValue
    
    public init() {
        self.wrappedValue = T.defaultValue
    }
    
    public init(wrappedValue: T.DFValue) {
        self.wrappedValue = wrappedValue
    }
}

extension ZDDefault: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            wrappedValue = T.defaultValue
        } else {
            self.wrappedValue = (try? container.decode(T.DFValue.self)) ?? T.defaultValue
        }
    }
}

extension ZDDefault: Equatable where T.DFValue: Equatable {}

public extension KeyedDecodingContainer {
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

/// 默认为`""`
public extension String {
    /// Empty "".count = 0
    enum Empty: ZDDefaultValue {
        public static let defaultValue = ""
    }
}

/// 默认为`0`
public extension Int {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0
    }
}

/// 默认为`0.0`
public extension Double {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0.0
    }
}

/// 默认为`0.0`
public extension Float {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0.0
    }
}

/// 默认为`0.0`
public extension CGFloat {
    enum Empty: ZDDefaultValue {
        public static let defaultValue = 0.0
    }
}

/// 默认为空数组
public extension Array {
    enum Empty<Element>: ZDDefaultValue where Element: Codable, Element: Equatable {
        public static var defaultValue: [Element] {
            [Element]()
        }
    }
}

/// 默认为空字典
extension Dictionary {
    enum Empty<K, V>: ZDDefaultValue where K: Codable & Hashable, V: Codable & Equatable {
        public static var defaultValue: [K: V] { [K: V]() }
    }
}

// MARK: - Custom Enum

/// 空集合，e.g: `String`、`Array` ...
public enum Empty<T>: ZDDefaultValue where T: Codable, T: Equatable, T: RangeReplaceableCollection {
    public static var defaultValue: T { T() }
}
