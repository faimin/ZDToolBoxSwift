//
//  CALayer+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2024/11/20.
//

import UIKit

public extension ZDSWrapper where T: CALayer {
    /// Renders the layer into an image.
    ///
    /// - Parameter size: Optional output size. Uses `base.frame.size` when `.zero`.
    /// - Returns: Snapshot image.
    ///
    /// Example:
    /// ```swift
    /// let image = view.layer.zd.snapshot()
    /// ```
    func snapshot(_ size: CGSize = .zero) -> UIImage {
        var newSize = size
        if newSize.width.isZero || newSize.height.isZero {
            newSize = base.frame.size
        }
        let render = UIGraphicsImageRenderer(size: newSize)
        let img = render.image { context in
            self.base.render(in: context.cgContext)
        }
        return img
    }

    /// Adds sublayers built by `ZDArrayBuilder`.
    ///
    /// - Parameter content: Builder closure producing sublayers.
    /// - Returns: The base layer.
    ///
    /// Example:
    /// ```swift
    /// view.layer.zd.components {
    ///     CALayer()
    ///     CAGradientLayer()
    /// }
    /// ```
    @discardableResult
    func components<V: CALayer>(@ZDArrayBuilder<V> _ content: () -> [V]) -> T {
        for item in content() {
            base.addSublayer(item)
        }
        return base
    }
}
