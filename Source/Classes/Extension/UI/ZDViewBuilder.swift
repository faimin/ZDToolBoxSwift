//
//  ZDViewBuilder.swift
//  Pods
//
//  Created by Zero.D.Saber on 2025/4/26.
//

// MARK: - ZDViewBuilder

@resultBuilder
public struct ZDViewBuilder<T> {
    // MARK: Nested Types

    public typealias Expression = T
    public typealias Component = [T]

    // MARK: Static Functions

    /// resultBuilder document:
    /// https://doc.swiftgg.team/documentation/the-swift-programming-language/attributes/#resultBuilder
    ///
    /// 在 Swift ResultBuilder 中，存在一个**类型链**的概念：
    ///    表达式 → buildExpression → 部分结果 → buildBlock → 最终结果
    ///
    /// `buildExpression` 输出 `[V]`，把所有变量转换成了数组，所以 `buildBlock` 期望的输入是 `[V]`
    public static func buildExpression(_ expression: Expression?) -> Component {
        guard let expression = expression else {
            return []
        }
        return [expression]
    }

    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return []
        }
        return component
    }

    public static func buildEither(first component: Component) -> Component {
        component
    }

    public static func buildEither(second component: Component) -> Component {
        component
    }

    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }

    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }
}
