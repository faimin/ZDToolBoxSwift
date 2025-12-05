//
//  ZDViewBuilder.swift
//  Pods
//
//  Created by Zero.D.Saber on 2025/4/26.
//

#if true

// MARK: - ZDBuildElement

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
    /// 在`if/switch`方法块中属于部分结果，也会执行`buildBlock`
    public static func buildExpression(_ expression: Expression?) -> Component {
        guard let expression = expression else {
            return []
        }
        return [expression]
    }

    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    /// if
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return []
        }
        return component
    }

    /// if-else / switch
    public static func buildEither(first component: Component) -> Component {
        component
    }

    /// if-else / switch
    public static func buildEither(second component: Component) -> Component {
        component
    }

    /// #if avaliable
    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }

    /// for-in
    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }

    /// 在if方法块中属于部分结果，也会执行buildBlock
    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    public static func buildPartialBlock(first: ZDViewBuilder<T>.Component) -> ZDViewBuilder<T>.Component {
        first
    }

    public static func buildPartialBlock(
        accumulated: ZDViewBuilder<T>.Component,
        next: ZDViewBuilder<T>.Component
    ) -> ZDViewBuilder<T>.Component {
        accumulated + next
    }
}

#else

// MARK: - ZDBuildElement

public enum ZDBuildElement<E> {
    case element(E)
    case elements([E])
    case empty

    // MARK: Computed Properties

    var values: [E] {
        switch self {
        case let .element(x): [x]
        case let .elements(xx): xx
        case .empty: []
        }
    }

    // MARK: Static Functions

    static func + (lhs: Self, rhs: Self) -> Self {
        .elements(lhs.values + rhs.values)
    }
}

// MARK: - ZDViewBuilder

@resultBuilder
public struct ZDViewBuilder<T> {
    // MARK: Nested Types

    public typealias Expression = T
    public typealias Component = ZDBuildElement<T>

    // MARK: Static Functions

    public static func buildExpression(_ expression: Expression?) -> Component {
        guard let expression else {
            return .empty
        }
        return .element(expression)
    }

    public static func buildExpression(_ expression: Expression) -> Component {
        .element(expression)
    }

    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return .empty
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

    public static func buildArray(_ components: [Component]) -> Component {
        .elements(components.flatMap(\.values))
    }

    public static func buildBlock(_ components: Component...) -> Component {
        let expressions = components.flatMap(\.values)
        return .elements(expressions)
    }

    public static func buildPartialBlock(first: ZDViewBuilder<T>.Component) -> ZDViewBuilder<T>.Component {
        first
    }

    public static func buildPartialBlock(
        accumulated: ZDViewBuilder<T>.Component,
        next: ZDViewBuilder<T>.Component
    ) -> ZDViewBuilder<T>.Component {
        accumulated + next
    }

    public static func buildFinalResult(_ component: Component) -> [Expression] {
        component.values
    }
}

#endif
