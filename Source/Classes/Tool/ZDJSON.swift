//
//  ZDJSON.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import CoreGraphics

// MARK: - ZDJSON

@dynamicMemberLookup
public enum ZDJSON {
    // MARK: - Case

    case dictionary([String: Self], [String: Any])
    case array([Self], [Any])
    case string(String)
    case int(Int)
    case int8(Int8)
    case int16(Int16)
    case int32(Int32)
    case int64(Int64)
    case uint(UInt)
    case uint8(UInt8)
    case uint16(UInt16)
    case uint32(UInt32)
    case uint64(UInt64)
    case double(Double)
    case float(CGFloat)
    case bool(Bool)
    case null

    // MARK: Computed Properties

    /// Returns dictionary representation.
    /// If the value is a JSON string, it attempts to parse it as a dictionary.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = "{\"name\":\"Zero\"}"
    /// print(json.dictionary["name"] as? String) // Optional("Zero")
    /// ```
    public var dictionary: [String: Any] {
        switch self {
        case let .dictionary(_, originValue):
            return originValue
        case let .string(value):
            let jsonDict = Self.string2Json(value) as? [String: Any]
            return jsonDict ?? [:]
        default:
            return [:]
        }
    }

    /// Returns array representation.
    /// If the value is a JSON string, it attempts to parse it as an array.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = "[1,2,3]"
    /// print(json.array.count) // 3
    /// ```
    public var array: [Any] {
        switch self {
        case let .array(_, originValue):
            return originValue
        case let .string(value):
            let jsonArray = Self.string2Json(value) as? [Any]
            return jsonArray ?? []
        default:
            return []
        }
    }

    /// Returns string representation.
    /// If the value is a dictionary or array, it attempts to serialize it to JSON string.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = ["id": 1]
    /// print(json.string) // {"id":1}
    /// ```
    public var string: String {
        switch self {
        case let .string(value):
            return value
        case let .bool(value):
            return value ? "1" : "0"
        case let .int(value):
            return "\(value)"
        case let .double(value):
            return "\(value)"
        case let .float(value):
            return "\(value)"
        case let .dictionary(_, value):
            return Self.json2String(value) ?? ""
        case let .array(_, value):
            return Self.json2String(value) ?? ""
        default:
            return ""
        }
    }

    /// Integer representation.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = "123"
    /// print(json.int) // 123
    /// ```
    public var int: Int {
        switch self {
        case let .int(value):
            return value
        case let .float(value):
            return Int(value)
        case let .string(value):
            return Int(value) ?? 0
        case let .double(value):
            return Int(value)
        case let .bool(value):
            return value ? 1 : 0
        default:
            return 0
        }
    }

    /// Double representation.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = "3.14"
    /// print(json.double) // 3.14
    /// ```
    public var double: Double {
        switch self {
        case let .double(value):
            return value
        case let .int(value):
            return Double(value)
        case let .float(value):
            return Double(value)
        case let .string(value):
            return Double(value) ?? 0.0
        case let .bool(value):
            return value ? 1.0 : 0.0
        default:
            return 0.0
        }
    }

    /// CGFloat representation.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = 12
    /// print(json.float) // 12.0
    /// ```
    public var float: CGFloat {
        switch self {
        case let .float(value):
            return value
        case let .string(value):
            return CGFloat(Double(value) ?? 0.0)
        case let .int(value):
            return CGFloat(value)
        case let .double(value):
            return CGFloat(value)
        case let .bool(value):
            return value ? 1.0 : 0.0
        default:
            return 0.0
        }
    }

    /// Boolean representation.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = "true"
    /// print(json.bool) // true
    /// ```
    public var bool: Bool {
        switch self {
        case let .bool(value):
            return value
        case let .string(value):
            if ["1", "true", "yes", "y"].contains(where: { value.caseInsensitiveCompare($0) == .orderedSame }) {
                return true
            }
            if ["0", "false", "no", "n"].contains(where: { value.caseInsensitiveCompare($0) == .orderedSame }) {
                return false
            }
            return false
        case let .int(value):
            return value != 0
        case let .double(value):
            return value != 0.0
        case let .float(value):
            return value != 0.0
        default:
            return false
        }
    }

    /// will deprecate in the future
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = ["id": 1]
    /// print(json.rawValue as Any)
    /// ```
    public var rawValue: Any? {
        switch self {
        case let .dictionary(_, originValue):
            // return wrapValue.mapValues { $0.object }
            return originValue.compactMapValues { $0 }
        case let .array(_, originValue):
            // return wrapValue.compactMap { $0.object }
            return originValue.compactMap { $0 }
        case let .string(value):
            return value
        case let .bool(value):
            return value
        case let .int(value):
            return value
        case let .double(value):
            return value
        case let .float(value):
            return value
        default:
            return nil
        }
    }

    // MARK: Lifecycle

    // MARK: - Initialize

    /// Initializes `ZDJSON` from supported input types.
    ///
    /// - Parameter object: Source object.
    ///
    /// Example:
    /// ```swift
    /// let json = ZDJSON(["name": "Zero"])
    /// ```
    public init(_ object: Any?) {
        guard let object = object else {
            self = .null
            return
        }

        switch object {
        case let value as Data:
            self = Self(data: value)
        case let value as [String: Any]:
            self = .dictionary(value.mapValues { Self($0) }, value)
        case let value as [Any?]:
            let mapedArray = value.compactMap { $0 }
            self = .array(mapedArray.map { Self($0) }, mapedArray)
        case let value as String:
            self = .string(value)
        case let value as Int:
            self = .int(value)
        case let value as Int8:
            self = .int8(value)
        case let value as Int16:
            self = .int16(value)
        case let value as Int32:
            self = .int32(value)
        case let value as Int64:
            self = .int64(value)
        case let value as UInt:
            self = .uint(value)
        case let value as UInt8:
            self = .uint8(value)
        case let value as UInt16:
            self = .uint16(value)
        case let value as UInt32:
            self = .uint32(value)
        case let value as UInt64:
            self = .uint64(value)
        case let value as Double:
            self = .double(value)
        case let value as CGFloat:
            self = .float(value)
        case let value as Float:
            self = .float(CGFloat(value))
        case let value as Bool:
            self = .bool(value)
        case let value as Self:
            self = value
        default:
            self = .null
        }
    }

    /// Initializes `ZDJSON` from JSON data.
    ///
    /// - Parameters:
    ///   - data: JSON data.
    ///   - options: JSON reading options.
    ///
    /// Example:
    /// ```swift
    /// let data = #"{"ok":true}"#.data(using: .utf8)!
    /// let json = ZDJSON(data: data)
    /// ```
    public init(data: Data, options: JSONSerialization.ReadingOptions = .fragmentsAllowed) {
        let object = try? JSONSerialization.jsonObject(with: data, options: options)
        #if DEBUG
        if object == nil {
            print("\(#function) => ⚠️ Invalid JSON")
        }
        #endif
        self.init(object)
    }

    /// Initializes `ZDJSON` from a JSON string.
    ///
    /// - Parameter jsonString: JSON text.
    ///
    /// Example:
    /// ```swift
    /// let json = ZDJSON(jsonString: #"{"id":1}"#)
    /// ```
    public init(jsonString: String) {
        let jsonData = jsonString.data(using: .utf8)
        self.init(jsonData)
    }

    // MARK: Functions

    // MARK: - DynamicMemberLookup

    /// Dynamic member lookup for dictionary values.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = ["user": ["name": "Zero"]]
    /// print(json.user["name"].string)
    /// ```
    public subscript(dynamicMember member: String) -> Self {
        switch self {
        case let .dictionary(wrapDict, _):
            return wrapDict[member] ?? .null
        case let .string(str):
            guard let dict = Self.string2Json(str) else {
                return .null
            }
            return ZDJSON(dict)[member]
        default:
            print("\(#function) => No matching key: \(member)")
        }
        return .null
    }

    // MARK: - Subcript

    /// Dictionary key lookup.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = ["name": "Zero"]
    /// print(json["name"].string) // Zero
    /// ```
    public subscript(key: String) -> Self {
        switch self {
        case let .dictionary(wrapDict, _):
            return wrapDict[key] ?? .null
        default:
            print("\(#function) => No matching key: \(key)")
        }
        return .null
    }

    /// Array index lookup.
    ///
    /// Example:
    /// ```swift
    /// let json: ZDJSON = [1, 2, 3]
    /// print(json[1].int) // 2
    /// ```
    public subscript(index: Int) -> Self {
        switch self {
        case let .array(wrapArray, _):
            return index >= wrapArray.count ? .null : wrapArray[index]
        default:
            print("\(#function) => No matching index: \(index)")
        }
        return .null
    }
}

// MARK: Codable

// Reference SwiftyJSON

extension ZDJSON: Codable {
    private static var codableTypes: [Codable.Type] {
        return [
            Bool.self,
            Int.self,
            Int8.self,
            Int16.self,
            Int32.self,
            Int64.self,
            UInt.self,
            UInt8.self,
            UInt16.self,
            UInt32.self,
            UInt64.self,
            Double.self,
            Float.self,
            CGFloat.self,
            String.self,
            [ZDJSON].self,
            [String: ZDJSON].self,
        ]
    }

    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.singleValueContainer(), !container.decodeNil() else {
            self = .null
            return
        }

        var object: Any?

        for type in Self.codableTypes {
            guard object == nil else {
                break
            }

            switch type {
            case let boolType as Bool.Type:
                object = try? container.decode(boolType)
            case let intType as Int.Type:
                object = try? container.decode(intType)
            case let int8Type as Int8.Type:
                object = try? container.decode(int8Type)
            case let int16Type as Int16.Type:
                object = try? container.decode(int16Type)
            case let int32Type as Int32.Type:
                object = try? container.decode(int32Type)
            case let int64Type as Int64.Type:
                object = try? container.decode(int64Type)
            case let uintType as UInt.Type:
                object = try? container.decode(uintType)
            case let uint8Type as UInt8.Type:
                object = try? container.decode(uint8Type)
            case let uint16Type as UInt16.Type:
                object = try? container.decode(uint16Type)
            case let uint32Type as UInt32.Type:
                object = try? container.decode(uint32Type)
            case let uint64Type as UInt64.Type:
                object = try? container.decode(uint64Type)
            case let doubleType as Double.Type:
                object = try? container.decode(doubleType)
            case let floatType as Float.Type:
                object = try? container.decode(floatType)
            case let cgFloatType as CGFloat.Type:
                object = try? container.decode(cgFloatType)
            case let stringType as String.Type:
                object = try? container.decode(stringType)
            case let jsonValueArrayType as [ZDJSON].Type:
                object = try? container.decode(jsonValueArrayType)
            case let jsonValueDictType as [String: ZDJSON].Type:
                object = try? container.decode(jsonValueDictType)
            default:
                break
            }
        }

        self.init(object)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .dictionary(wrapedDictionary, _):
            try container.encode(wrapedDictionary)
        case let .array(wrapedArray, _):
            try container.encode(wrapedArray)
        case let .string(stringValue):
            try container.encode(stringValue)
        case let .int(intValue):
            try container.encode(intValue)
        case let .int8(value):
            try container.encode(value)
        case let .int16(value):
            try container.encode(value)
        case let .int32(value):
            try container.encode(value)
        case let .int64(value):
            try container.encode(value)
        case let .uint(value):
            try container.encode(value)
        case let .uint8(value):
            try container.encode(value)
        case let .uint16(value):
            try container.encode(value)
        case let .uint32(value):
            try container.encode(value)
        case let .uint64(value):
            try container.encode(value)
        case let .double(doubleValue):
            try container.encode(doubleValue)
        case let .float(floatValue):
            try container.encode(floatValue)
        case let .bool(boolValue):
            try container.encode(boolValue)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: ExpressibleByDictionaryLiteral

extension ZDJSON: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = Any?

    public init(dictionaryLiteral elements: (Key, Value)...) {
        let dict = elements.reduce(into: [String: Any]()) { inoutDict, element in
            let (key, value) = element
            inoutDict[key] = value
        }
        self.init(dict)
    }
}

// MARK: ExpressibleByArrayLiteral

extension ZDJSON: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Any?

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        let newArray = elements.compactMap { $0 }
        self.init(newArray)
    }
}

// MARK: ExpressibleByStringLiteral

extension ZDJSON: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }

    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }

    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}

// MARK: ExpressibleByIntegerLiteral

extension ZDJSON: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

// MARK: ExpressibleByFloatLiteral

extension ZDJSON: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

// MARK: ExpressibleByBooleanLiteral

extension ZDJSON: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

// MARK: - Private Func

public extension ZDJSON {
    /// Parses a JSON string into dictionary or array.
    ///
    /// - Parameter jsonString: JSON text.
    /// - Returns: Parsed JSON object.
    ///
    /// Example:
    /// ```swift
    /// let object = ZDJSON.string2Json(#"{"id":1}"#)
    /// ```
    static func string2Json(_ jsonString: String) -> Any? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    }

    /// Serializes dictionary or array to JSON string.
    ///
    /// - Parameter jsonObject: JSON object to serialize.
    /// - Returns: JSON text if serialization succeeds.
    ///
    /// Example:
    /// ```swift
    /// let text = ZDJSON.json2String(["id": 1])
    /// ```
    static func json2String(_ jsonObject: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}
