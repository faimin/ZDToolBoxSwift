//
//  ZDCommonPopupView.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/10/14.
//

import Combine
import UIKit

// MARK: - ZDPopupAnimationType

public enum ZDPopupAnimationType {
    case bottomUp
    case center
}

// MARK: - ZDCommonPopupView

@MainActor
public class ZDCommonPopupView<T: UIView>: UIControl {
    // MARK: Properties

    /// Whether tapping outside closes the popup. Default is `true`.
    @objc public var enableCloseOnTouchOutside: Bool = true

    private lazy var contentView = T()

    private lazy var animationType: ZDPopupAnimationType = .bottomUp

    // MARK: Lifecycle

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(white: 0, alpha: 0.3)

        addTarget(self, action: #selector(onClick), for: .touchUpInside)
    }

    // MARK: Functions

    @objc
    private func onClick() {
        guard enableCloseOnTouchOutside else {
            return
        }

        dismiss()
    }
}

public extension ZDCommonPopupView {
    /// Shows a popup view in the given container.
    ///
    /// - Parameters:
    ///   - container: Host container view.
    ///   - animationType: Popup animation style.
    ///   - configure: Content and popup configuration callback.
    ///   - completion: Callback invoked after show animation completes.
    /// - Returns: Popup instance, or `nil` when container is `nil`.
    ///
    /// Example:
    /// ```swift
    /// let popup = ZDCommonPopupView<UIView>.showInContainer(
    ///     view,
    ///     animationType: .bottomUp,
    ///     configure: { content, _ in
    ///         content.backgroundColor = .white
    ///     },
    ///     completion: nil
    /// )
    /// ```
    @discardableResult
    static func showInContainer(
        _ container: UIView?,
        animationType: ZDPopupAnimationType? = .bottomUp,
        configure: ((T, Self) -> Void)?,
        completion: ((Self) -> Void)?
    ) -> Self? {
        guard let container = container else {
            #if DEBUG
            assert(container != nil)
            #endif
            return nil
        }

        let popupView = Self()
        popupView.frame = container.bounds
        popupView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupView.animationType = animationType ?? .bottomUp
        container.addSubview(popupView)

        let contentView = popupView.contentView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.isHidden = true
        popupView.addSubview(contentView)

        // Add layout constraints.
        switch animationType {
        case .bottomUp:
            NSLayoutConstraint.activate([
                contentView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: popupView.bottomAnchor),
            ])
        case .center:
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
            ])
        case .none:
            break
        }

        // Apply external configuration.
        configure?(contentView, popupView)
        #if DEBUG
        assert(!contentView.subviews.isEmpty, "Did you forget to add subviews?")
        #endif

        // Force layout to get the final frame.
        contentView.layoutIfNeeded()

        switch animationType {
        case .center:
            contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            contentView.isHidden = false
            UIView.animate(withDuration: 0.25) {
                contentView.transform = CGAffineTransformIdentity
            } completion: { finished in
                guard finished, let completion else { return }
                completion(popupView)
            }
        case .bottomUp:
            /*
             let maxWidth = contentView.frame.width > 0 ? contentView.frame.width : popupView.frame.width
             let contentSize = contentView.systemLayoutSizeFitting(CGSize(
                 width: maxWidth,
                 height: CGFloat.greatestFiniteMagnitude
             ))
             */
            let x = contentView.frame.minX
            contentView.frame.origin = CGPoint(x: x, y: popupView.frame.height)
            contentView.isHidden = false
            UIView.animate(withDuration: 0.25) {
                contentView.frame.origin = CGPoint(
                    x: x,
                    y: popupView.frame.height - contentView.frame.height
                )
            } completion: { finished in
                guard finished, let completion else { return }
                completion(popupView)
            }
        case .none:
            break
        }

        return popupView
    }

    /// Dismisses the popup view with animation.
    ///
    /// - Parameter completion: Callback invoked after dismiss animation completes.
    ///
    /// Example:
    /// ```swift
    /// popup?.dismiss()
    /// ```
    func dismiss(_ completion: ((ZDCommonPopupView<T>) -> Void)? = nil) {
        alpha = 1
        UIView.animate(withDuration: 0.25) {
            self.alpha = 0

            switch self.animationType {
            case .center:
                self.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            default:
                self.contentView.frame.origin = CGPoint(x: self.contentView.frame.minX, y: self.frame.height)
            }
        } completion: { finished in
            self.alpha = 1
            guard finished else { return }
            completion?(self)
            self.contentView.removeFromSuperview()
            self.removeFromSuperview()
        }
    }

    @available(iOS 13.0, *)
    @MainActor
    /// Dismisses the popup and returns a publisher that emits when dismissal completes.
    ///
    /// - Returns: A publisher emitting dismissed popup instance.
    ///
    /// Example:
    /// ```swift
    /// popup.dismissPublisher()
    ///     .sink { _ in print("dismissed") }
    ///     .store(in: object)
    /// ```
    func dismissPublisher() -> AnyPublisher<ZDCommonPopupView<T>, Never> {
        return Future<ZDCommonPopupView<T>, Never> { promise in
            self.dismiss { popupView in
                promise(Result.success(popupView))
            }
        }.eraseToAnyPublisher()
    }
}
