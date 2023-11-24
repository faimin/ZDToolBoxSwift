//
//  View+ZDExtension.swift
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


extension ZDSWraper where T: ZDView {
    
    // MARK: - Frame
    
    public var x: CGFloat {
        get {
            self.base.frame.origin.x
        }
        set {
            self.base.frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            self.base.frame.origin.x
        }
        set {
            self.base.frame.origin.y = newValue
        }
    }
    
    public var width: CGFloat {
        get {
            self.base.frame.size.width
        }
        set {
            self.base.frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            self.base.frame.size.height
        }
        set {
            self.base.frame.size.height = newValue
        }
    }
    
    public var left: CGFloat {
        get {
            self.x
        }
        set {
            self.x = newValue
        }
    }
    
    public var right: CGFloat {
        get {
            self.x + self.width
        }
        set {
            self.x = newValue - self.width
        }
    }
    
    public var top: CGFloat {
        get {
            self.y
        }
        set {
            self.y = newValue
        }
    }
    
    public var bottom: CGFloat {
        get {
            self.y + self.height
        }
        set {
            self.y = newValue - self.height
        }
    }
    
    public var centerX: CGFloat {
        get {
            self.x + self.width * 0.5
        }
        set {
            self.x = newValue - self.width * 0.5
        }
    }
    
    public var centerY: CGFloat {
        get {
            self.y + self.height * 0.5
        }
        set {
            self.y = newValue - self.height * 0.5
        }
    }
    
    public var center: CGPoint {
        get {
            return CGPoint(x: self.centerX, y: self.centerY)
        }
        set {
            self.centerX = newValue.x
            self.centerY = newValue.y
        }
    }
    
    public var boundsCenterX: CGFloat {
        self.width * 0.5
    }
    
    public var boundsCenterY: CGFloat {
        self.height * 0.5
    }
    
    public var boundsCenter: CGPoint {
        CGPoint(x: self.width * 0.5, y: self.height * 0.5)
    }
    
    #if os(iOS) || os(tvOS)
    @discardableResult
    public func roundCorners(
        _ corners: UIRectCorner = UIRectCorner.allCorners,
        radius: CGFloat
    ) -> T {
        let path = UIBezierPath(roundedRect: self.base.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.base.layer.mask = mask
        
        return self.base
    }
    #endif
    
    @available(macOS 10.13, iOS 11.0, tvOS 11, *)
    @discardableResult
    public func roundCorners(
        _ corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner],
        radius: CGFloat
    ) -> T {
        
        #if os(iOS) || os(tvOS)
        self.base.layer.cornerRadius = radius
        self.base.layer.maskedCorners = corners
        #else
        self.base.layer?.cornerRadius = radius
        self.base.layer?.maskedCorners = corners
        #endif
        return self.base
    }
}

public extension ZDSWraper where T: ZDView {
    
    /// Convenience function to ease creating new views.
    ///
    /// - Parameter builder: A function that takes the newly created view.
    ///
    /// Usage:
    /// ```
    ///    private let button: UIButton = .zd.build { button in
    ///        button.setTitle("Tap me!", for state: .normal)
    ///        button.backgroundColor = .systemPink
    ///    }
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
        var nextResponder: ZDResponder? = self.base
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
    
}
