//
//  ZDJSON.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import CoreGraphics

@dynamicMemberLookup
public enum ZDJSON {
    
    // MARK: - Case
    
    case dictionary([String: Self], [String: Any])
    case array([Self], [Any])
    case string(String)
    case int(Int)
    case double(Double)
    case float(CGFloat)
    case bool(Bool)
    case null
    
    // MARK: - Initialize
    
    /// 根据不同的类型创建ZDJSON
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
    
    /// 把Data对象转换成JSON对象
    public init(data: Data, options: JSONSerialization.ReadingOptions = .fragmentsAllowed) {
        let object = try? JSONSerialization.jsonObject(with: data, options: options)
        #if DEBUG
        if object == nil {
            print("\(#function) => ⚠️json不合法")
        }
        #endif
        self.init(object)
    }
    
    /// 把String对象转换成JSON对象
    public init(jsonString: String) {
        let jsonData = jsonString.data(using: .utf8)
        self.init(jsonData)
    }
    
    // MARK: - DynamicMemberLookup
    
    public subscript(dynamicMember member: String) -> Self {
        switch self {
        case .dictionary(let wrapDict, _):
            return wrapDict[member] ?? .null
        default:
            print("\(#function) => 匹配失败：key = \(member)")
        }
        return .null
    }
    
    // MARK: - Subcript
    
    public subscript(key: String) -> Self {
        switch self {
        case .dictionary(let wrapDict, _):
            return wrapDict[key] ?? .null
        default:
            print("\(#function) => 匹配失败：key = \(key)")
        }
        return .null
    }
    
    public subscript(index: Int) -> Self {
        switch self {
        case .array(let wrapArray, _):
            return index >= wrapArray.count ? .null : wrapArray[index]
        default:
            print("\(#function) => 匹配失败：index = \(index)")
        }
        return .null
    }
    
    // MARK: - Computed Properties
    
    /// 如果是字符串，那么会尝试转为字典
    public var dictionary: [String: Any] {
        switch self {
        case .dictionary(_, let originValue):
            return originValue
        case .string(let value):
            let jsonDict = string2Json(value) as? [String: Any]
            return jsonDict ?? [:]
        default:
            return [:]
        }
    }
    
    /// 如果是字符串，那么会尝试转为数组
    public var array: [Any] {
        switch self {
        case .array(_, let originValue):
            return originValue
        case .string(let value):
            let jsonArray = string2Json(value) as? [Any]
            return jsonArray ?? []
        default:
            return []
        }
    }
    
    /// 如果是字典或者数组，那么会尝试转为字符串
    public var string: String {
        switch self {
        case .string(let value):
            return value
        case .bool(let value):
            return value ? "1" : "0"
        case .int(let value):
            return "\(value)"
        case .double(let value):
            return "\(value)"
        case .float(let value):
            return "\(value)"
        case .dictionary(_, let value):
            return json2String(value) ?? ""
        case .array(_, let value):
            return json2String(value) ?? ""
        default:
            return ""
        }
    }
    
    public var int: Int {
        switch self {
        case .int(let value):
            return value
        case .float(let value):
            return Int(value)
        case .string(let value):
            return Int(value) ?? 0
        case .double(let value):
            return Int(value)
        case .bool(let value):
            return value ? 1 : 0
        default:
            return 0
        }
    }
    
    public var double: Double {
        switch self {
        case .double(let value):
            return value
        case .int(let value):
            return Double(value)
        case .float(let value):
            return Double(value)
        case .string(let value):
            return Double(value) ?? 0.0
        case .bool(let value):
            return value ? 1.0 : 0.0
        default:
            return 0.0
        }
    }
    
    public var float: CGFloat {
        switch self {
        case .float(let value):
            return value
        case .string(let value):
            return CGFloat(Double(value) ?? 0.0)
        case .int(let value):
            return CGFloat(value)
        case .double(let value):
            return CGFloat(value)
        case .bool(let value):
            return value ? 1.0 : 0.0
        default:
            return 0.0
        }
    }
    
    public var bool: Bool {
        switch self {
        case .bool(let value):
            return value
        case .string(let value):
            if ["1", "true", "yes", "y"].contains(where: { value.caseInsensitiveCompare($0) == .orderedSame }) {
                return true
            } else if ["0", "false", "no", "n"].contains(where: { value.caseInsensitiveCompare($0) == .orderedSame }) {
                return false
            }
            return false
        case .int(let value):
            return value != 0
        case .double(let value):
            return value != 0.0
        case .float(let value):
            return value != 0.0
        default:
            return false
        }
    }
    
    // will deprecate in the future
    public var rawValue: Any? {
        switch self {
        case .dictionary(_, let originValue):
            // return wrapValue.mapValues { $0.object }
            return originValue.compactMapValues { $0 }
        case .array(_, let originValue):
            // return wrapValue.compactMap { $0.object }
            return originValue.compactMap { $0 }
        case .string(let value):
            return value
        case .bool(let value):
            return value
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .float(let value):
            return value
        default:
            return nil
        }
    }
}

// MARK: - Codable
// Reference SwiftyJSON

// MARK: Encodable

extension ZDJSON: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .dictionary(let wrapedDictionary, _):
            try container.encode(wrapedDictionary)
        case .array(let wrapedArray, _):
            try container.encode(wrapedArray)
        case .string(let stringValue):
            try container.encode(stringValue)
        case .int(let intValue):
            try container.encode(intValue)
        case .double(let doubleValue):
            try container.encode(doubleValue)
        case .float(let floatValue):
            try container.encode(floatValue)
        case .bool(let boolValue):
            try container.encode(boolValue)
        case .null:
            try container.encodeNil()
        }
    }
}

// MARK: Decodable

extension ZDJSON: Decodable {
    
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
            String.self,
            [ZDJSON].self,
            [String: ZDJSON].self
        ]
    }
    
    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.singleValueContainer(), !container.decodeNil() else {
            self = .null
            return
        }
        
        var object: Any?
        
        for type in Self.codableTypes {
            if object != nil {
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
}

// MARK: - ExpressibleByLiteral

extension ZDJSON: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = Any?
    
    public init(dictionaryLiteral elements: (Key, Value)...) {
        let dict = elements.reduce(into: [String: Any]()) { (inoutDict, element) in
            let (key, value) = element
            inoutDict[key] = value
        }
        self.init(dict)
    }
}

extension ZDJSON: ExpressibleByArrayLiteral {
    public typealias ArrayLiteralElement = Any?
    
    public init(arrayLiteral elements: ArrayLiteralElement...) {
        let newArray = elements.compactMap { $0 }
        self.init(newArray)
    }
}

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

extension ZDJSON: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value)
    }
}

extension ZDJSON: ExpressibleByFloatLiteral {
    
    public init(floatLiteral value: FloatLiteralType) {
        self.init(value)
    }
}

extension ZDJSON: ExpressibleByBooleanLiteral {
    
    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value)
    }
}

// MARK: - Private Func

extension ZDJSON {
    
    /// 字符串转字典或者数组
    private func string2Json(_ jsonString: String) -> Any? {
        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
    }
    
    /// 字典或者数组转字符串
    private func json2String(_ jsonObject: Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

