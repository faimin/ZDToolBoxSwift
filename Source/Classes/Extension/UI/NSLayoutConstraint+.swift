//
//  NSLayoutConstraint+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/2.
//

@MainActor
public extension ZDSWrapper where T: NSLayoutConstraint {
    static func activate(@ZDArrayBuilder<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        let constraintArr = constraints()
        guard !constraintArr.isEmpty else {
            return
        }
        T.activate(constraintArr)
    }

    static func deactivate(@ZDArrayBuilder<NSLayoutConstraint> _ constraints: () -> [NSLayoutConstraint]) {
        let constraintArr = constraints()
        guard !constraintArr.isEmpty else {
            return
        }
        T.deactivate(constraintArr)
    }
}
