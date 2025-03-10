//
//  ZDGradientView.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/2/8.
//

@objc
public final class ZDGradientView: UIView {
    @objc public var gradientLayer: CAGradientLayer {
        guard let layer = layer as? CAGradientLayer else {
            fatalError("impossible appear")
        }
        return layer
    }

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
