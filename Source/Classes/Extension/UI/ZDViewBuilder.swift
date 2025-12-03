//
//  ZDViewBuilder.swift
//  Pods
//
//  Created by Zero.D.Saber on 2025/4/26.
//

// MARK: - ZDViewBuilder

@resultBuilder
public struct ZDViewBuilder<V> {
    /// resultBuilder document:
    /// https://doc.swiftgg.team/documentation/the-swift-programming-language/attributes/#resultBuilder
    ///
    /// 在 Swift ResultBuilder 中，存在一个**类型链**的概念：
    ///    表达式 → buildExpression → 部分结果 → buildBlock → 最终结果
    ///
    /// `buildExpression` 输出 `[V]`，把所有变量转换成了数组，所以 `buildBlock` 期望的输入是 `[V]`
    public static func buildExpression(_ expression: V?) -> [V] {
        guard let expression = expression else {
            return []
        }
        return [expression]
    }

    public static func buildExpression(_ expression: V) -> [V] {
        [expression]
    }

    public static func buildOptional(_ component: [V]?) -> [V] {
        guard let component = component else {
            return []
        }
        return component
    }

    public static func buildEither(first component: [V]) -> [V] {
        component
    }

    public static func buildEither(second component: [V]) -> [V] {
        component
    }

    public static func buildLimitedAvailability(_ component: [V]) -> [V] {
        component
    }

    public static func buildBlock(_ components: [V]...) -> [V] {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [[V]]) -> [V] {
        components.flatMap { $0 }
    }
}
