//
//  NSLayoutConstraint+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/2.
//

public extension NSLayoutConstraint {
    static func activate(@ZDViewBuilder<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        let constraintArr = constraints()
        guard !constraintArr.isEmpty else {
            return
        }
        NSLayoutConstraint.activate(constraintArr)
    }

    static func deactivate(@ZDViewBuilder<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        let constraintArr = constraints()
        guard !constraintArr.isEmpty else {
            return
        }
        NSLayoutConstraint.deactivate(constraintArr)
    }
}
