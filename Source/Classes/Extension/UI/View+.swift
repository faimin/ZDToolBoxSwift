//
//  View+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/10.
//

#if os(iOS) || os(tvOS)
    import UIKit

    public typealias ZDView = UIView
    public typealias ZDViewController = UIViewController
    public typealias ZDResponder = UIResponder
#else
    import AppKit

    public typealias ZDView = NSView
    public typealias ZDViewController = NSViewController
    public typealias ZDResponder = NSResponder
#endif

public protocol ZDComponentProtocol: AnyObject {}
extension ZDView: ZDComponentProtocol {}
extension CALayer: ZDComponentProtocol {}
extension UILayoutGuide: ZDComponentProtocol {}

@MainActor
public extension ZDSWraper where T: ZDView {
    // MARK: - Frame

    var x: CGFloat {
        get {
            base.frame.origin.x
        }
        set {
            base.frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            base.frame.origin.x
        }
        set {
            base.frame.origin.y = newValue
        }
    }

    var width: CGFloat {
        get {
            base.frame.size.width
        }
        set {
            base.frame.size.width = newValue
        }
    }

    var height: CGFloat {
        get {
            base.frame.size.height
        }
        set {
            base.frame.size.height = newValue
        }
    }

    var left: CGFloat {
        get {
            x
        }
        set {
            x = newValue
        }
    }

    var right: CGFloat {
        get {
            x + width
        }
        set {
            x = newValue - width
        }
    }

    var top: CGFloat {
        get {
            y
        }
        set {
            y = newValue
        }
    }

    var bottom: CGFloat {
        get {
            y + height
        }
        set {
            y = newValue - height
        }
    }

    var centerX: CGFloat {
        get {
            x + width * 0.5
        }
        set {
            x = newValue - width * 0.5
        }
    }

    var centerY: CGFloat {
        get {
            y + height * 0.5
        }
        set {
            y = newValue - height * 0.5
        }
    }

    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }

    var boundsCenterX: CGFloat {
        width * 0.5
    }

    var boundsCenterY: CGFloat {
        height * 0.5
    }

    var boundsCenter: CGPoint {
        CGPoint(x: width * 0.5, y: height * 0.5)
    }

    #if os(iOS) || os(tvOS)
        @discardableResult
        func roundCorners(
            _ corners: UIRectCorner = UIRectCorner.allCorners,
            radius: CGFloat
        ) -> T {
            let path = UIBezierPath(roundedRect: base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))

            let mask = CAShapeLayer()
            mask.path = path.cgPath

            base.layer.mask = mask

            return base
        }
    #endif

    @available(macOS 10.13, iOS 11.0, tvOS 11, *)
    @discardableResult
    func roundCorners(
        _ corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner],
        radius: CGFloat
    ) -> T {
        #if os(iOS) || os(tvOS)
            base.layer.cornerRadius = radius
            base.layer.maskedCorners = corners
        #else
            base.layer?.cornerRadius = radius
            base.layer?.maskedCorners = corners
        #endif
        return base
    }
}

@MainActor
public extension ZDSWraper where T: ZDView {
    /// Convenience function to ease creating new views.
    ///
    /// - Parameter builder: A function that takes the newly created view.
    ///
    /// Usage:
    /// ```swift
    /// private let button: UIButton = .zd.build { button in
    ///     button.setTitle("Tap me!", for state: .normal)
    ///     button.backgroundColor = .systemPink
    /// }
    /// ```
    static func build(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        builder?(view)

        return view
    }

    @discardableResult
    func addSubviews(_ subviews: T ...) -> Self {
        subviews.forEach { self.base.addSubview($0) }
        return self
    }

    func viewController() -> ZDViewController? {
        var nextResponder: ZDResponder? = base
        while nextResponder != nil {
            if let vc = nextResponder as? ZDViewController {
                return vc
            }
            #if os(iOS) || os(tvOS)
                nextResponder = nextResponder?.next
            #else
                nextResponder = nextResponder?.nextResponder
            #endif
        }

        return nil
    }

    /// ViewBuilder
    ///
    /// - Parameter components: A block for components, e.g UI/NSView、CALayer、UILayoutGuide
    ///
    /// @code
    /// ```swift
    /// view.addComponents {
    ///     email
    ///     password
    ///     login
    ///     layoutGuide
    ///     gradientLayer
    /// }
    /// ```
    /// @endcode
    @discardableResult
    func addComponents(@ZDViewBuilder<any ZDComponentProtocol> _ components: () -> [any ZDComponentProtocol]) -> T {
        for item in components() {
            if let view = item as? UIView {
                base.addSubview(view)
            } else if let guide = item as? UILayoutGuide {
                base.addLayoutGuide(guide)
            } else if let layer = item as? CALayer {
                base.layer.addSublayer(layer)
            } else {
                assertionFailure("不支持的类型 => \(String(describing: item))")
            }
        }
        return base
    }

    /// Checkes if the view is (mostly) visible to user or not.
    /// Internaly it checks following things
    ///  - Should NOT be hidden
    ///  - Should NOT be completely transparent
    ///  - Bound should NOT be empty
    ///  - Should be in some window i.e. in view heirarchy
    ///  - Center should be directly visible to user i.e. NOT overlapped with other views
    var isMostlyVisible: Bool {
        guard !base.isHidden,
              base.alpha > 0,
              !base.bounds.isEmpty,
              let window = base.window,
              window.hitTest(window.convert(base.center, from: base.superview), with: nil) == base
        else {
            return false
        }

        return true
    }

    var screenshot: UIImage? {
        /*
         defer {
             UIGraphicsEndImageContext()
         }
         UIGraphicsBeginImageContextWithOptions(base.frame.size, false, 0)
         guard let context = UIGraphicsGetCurrentContext() else { return nil }
         base.layer.render(in: context)
         return UIGraphicsGetImageFromCurrentImageContext()
         */
        let render = UIGraphicsImageRenderer(bounds: base.bounds)
        return render.image { renderContext in
            self.base.layer.render(in: renderContext.cgContext)
        }
    }
}
