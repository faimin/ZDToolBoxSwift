//
//  ZDArrayBuilder.swift
//  Pods
//
//  Created by Zero.D.Saber on 2025/4/26.
//

#if true

// MARK: - ZDBuildElement

@resultBuilder
public struct ZDArrayBuilder<T> {
    // MARK: Nested Types

    public typealias Expression = T
    public typealias Component = [T]

    // MARK: Static Functions

    /// resultBuilder document:
    /// https://doc.swiftgg.team/documentation/the-swift-programming-language/attributes/#resultBuilder
    ///
    /// In Swift ResultBuilder there is a type flow:
    /// expression -> buildExpression -> partial result -> buildBlock -> final result
    ///
    /// `buildExpression` returns `[V]`, so all expressions become arrays and
    /// `buildBlock` receives `[V]` as input.
    /// Branches such as `if/switch` are partial results and also go through `buildBlock`.
    ///
    /// Example:
    /// ```swift
    /// NSLayoutConstraint.zd.activate {
    ///     view.widthAnchor.constraint(equalToConstant: 100)
    ///     view.heightAnchor.constraint(equalToConstant: 44)
    /// }
    /// ```
    public static func buildExpression(_ expression: Expression?) -> Component {
        guard let expression = expression else {
            return []
        }
        return [expression]
    }

    /// Wraps a non-optional expression into component array.
    public static func buildExpression(_ expression: Expression) -> Component {
        [expression]
    }

    /// if
    /// Handles optional branch result.
    public static func buildOptional(_ component: Component?) -> Component {
        guard let component = component else {
            return []
        }
        return component
    }

    /// if-else / switch
    /// Handles first branch in conditional builder.
    public static func buildEither(first component: Component) -> Component {
        component
    }

    /// if-else / switch
    /// Handles second branch in conditional builder.
    public static func buildEither(second component: Component) -> Component {
        component
    }

    /// #if avaliable
    /// Handles availability-constrained branch.
    public static func buildLimitedAvailability(_ component: Component) -> Component {
        component
    }

    /// for-in
    /// Flattens array of partial components from loops.
    public static func buildArray(_ components: [Component]) -> Component {
        components.flatMap { $0 }
    }

    /// `if` blocks are partial results and also run through `buildBlock`.
    ///
    /// - Parameter components: Partial component arrays.
    /// - Returns: Flattened component array.
    public static func buildBlock(_ components: Component...) -> Component {
        components.flatMap { $0 }
    }

    /// Handles first partial block in incremental builder flow.
    public static func buildPartialBlock(first: ZDArrayBuilder<T>.Component) -> ZDArrayBuilder<T>.Component {
        first
    }

    /// Appends next partial block in incremental builder flow.
    public static func buildPartialBlock(
        accumulated: ZDArrayBuilder<T>.Component,
        next: ZDArrayBuilder<T>.Component
    ) -> ZDArrayBuilder<T>.Component {
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

// MARK: - ZDArrayBuilder

@resultBuilder
public struct ZDArrayBuilder<T> {
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

    public static func buildPartialBlock(first: ZDArrayBuilder<T>.Component) -> ZDArrayBuilder<T>.Component {
        first
    }

    public static func buildPartialBlock(
        accumulated: ZDArrayBuilder<T>.Component,
        next: ZDArrayBuilder<T>.Component
    ) -> ZDArrayBuilder<T>.Component {
        accumulated + next
    }

    public static func buildFinalResult(_ component: Component) -> [Expression] {
        component.values
    }
}

#endif
