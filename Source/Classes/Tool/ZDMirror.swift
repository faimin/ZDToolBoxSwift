//
//  ZDMirror.swift
//  Pods
//
//  Created by Zero_D_Saber on 2026/1/21.
//

public enum ZDMirror {
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
