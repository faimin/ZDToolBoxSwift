//
//  ZDLayoutConstraintBuilder.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/2.
//

import UIKit

@resultBuilder
public struct ZDLayoutConstraintBuilder {
    public static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        components
    }

    public static func buildArray(_ components: [NSLayoutConstraint]) -> [NSLayoutConstraint] {
        components
    }

    public static func buildOptional(_ component: [NSLayoutConstraint]?) -> [NSLayoutConstraint] {
        component ?? []
    }

    public static func buildEither(first component: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [component]
    }

    public static func buildEither(second component: NSLayoutConstraint) -> [NSLayoutConstraint] {
        [component]
    }
}
