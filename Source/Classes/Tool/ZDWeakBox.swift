//
//  ZDWeakBox.swift
//  Pods
//
//  Created by Zero_D_Saber on 2024/12/30.
//

public struct ZDWeakBox<T: AnyObject> {
    // MARK: Properties

    /// Weakly stored object reference.
    public weak var object: T?

    // MARK: Lifecycle

    /// Creates a weak container for the given object.
    ///
    /// - Parameter object: Object to store weakly.
    ///
    /// Example:
    /// ```swift
    /// let vc = UIViewController()
    /// let box = ZDWeakBox(object: vc)
    /// print(box.object != nil) // true
    /// ```
    public init(object: T? = nil) {
        self.object = object
    }
}
