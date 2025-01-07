//
//  ZDWeakBox.swift
//  Pods
//
//  Created by Zero_D_Saber on 2024/12/30.
//

public struct ZDWeakBox<T: AnyObject> {
    // MARK: Properties

    public weak var object: T?

    // MARK: Lifecycle

    public init(object: T? = nil) {
        self.object = object
    }
}
