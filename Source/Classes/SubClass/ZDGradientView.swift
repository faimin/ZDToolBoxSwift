//
//  ZDGradientView.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/2/8.
//

public class ZDGradientView: UIView {
    // MARK: Overridden Properties

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    // MARK: Properties

    @objc public var colors: [UIColor]? {
        didSet {
            gradientLayer.colors = colors?.map(\.cgColor)
        }
    }

    @objc public var startPoint: CGPoint = .init(x: 0, y: 0.5) {
        didSet {
            gradientLayer.startPoint = startPoint
        }
    }

    @objc public var endPoint: CGPoint = .init(x: 1, y: 0.5) {
        didSet {
            gradientLayer.endPoint = endPoint
        }
    }

    @objc public var locations: [NSNumber]? {
        didSet {
            gradientLayer.locations = locations
        }
    }

    // MARK: Computed Properties

    @objc public var gradientLayer: CAGradientLayer {
        guard let layer = layer as? CAGradientLayer else {
            fatalError("impossible appear")
        }
        return layer
    }
}
