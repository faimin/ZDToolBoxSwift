//
//  ZDMirror.swift
//  Pods
//
//  Created by Zero_D_Saber on 2026/1/21.
//

public enum ZDMirror {
    /// Returns all stored properties for an instance, including superclass properties.
    ///
    /// - Parameter value: Value to introspect.
    /// - Returns: A dictionary keyed by property name.
    ///
    /// Example:
    /// ```swift
    /// final class User {
    ///     let id: Int = 1
    ///     let name: String = "Zero"
    /// }
    /// let props = ZDMirror.properties(User())
    /// print(props["name"] as? String) // Optional("Zero")
    /// ```
    public static func properties(_ value: Any) -> [String: Any] {
        var propertyKV = [String: Any]()
        let m = Mirror(reflecting: value)

        func recursiveProperty(_ mirror: Mirror) {
            for child in mirror.children {
                guard let key = child.label else {
                    continue
                }
                propertyKV[key] = child.value
            }

            guard let supperMirror = mirror.superclassMirror else {
                return
            }
            recursiveProperty(supperMirror)
        }

        recursiveProperty(m)

        return propertyKV
    }
}
