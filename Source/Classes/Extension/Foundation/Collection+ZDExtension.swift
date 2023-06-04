//
//  Collection+ZDExtension.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

public extension Collection {
    
    /// 安全取值
    /// - Parameters index: 下标
    /// - Notes 来源：https://github.com/Luur/SwiftTips
    subscript(zd index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    /// 安全取值并提供默认值
    /// - Parameters
    ///     - index: 下标
    ///     - defaultValue: 默认值
    /// - Notes
    subscript(zd index: Index, defaultValue: Element) -> Element {
        return indices.contains(index) ? self[index] : defaultValue
    }
}

