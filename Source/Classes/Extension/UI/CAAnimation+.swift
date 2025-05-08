//
//  CAAnimation+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2024/10/26.
//

import Foundation

private final class CAAnimationDelegateProxy: NSObject, CAAnimationDelegate {
    fileprivate lazy var onStartActions = [(CAAnimation) -> Void]()
    fileprivate lazy var onStopActions = [(CAAnimation, Bool) -> Void]()

    // MARK: CAAnimationDelegate

    func animationDidStart(_ anim: CAAnimation) {
        onStartActions.forEach { $0(anim) }
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        onStopActions.forEach { $0(anim, flag) }
    }
}

public extension ZDSWraper where T: CAAnimation {
    /// Create delegate proxy if it doesn't exist
    ///
    /// The delegate object is retained by the receiver
    ///
    /// - Returns: CAAnimationDelegateProxy
    private var delegateProxy: CAAnimationDelegateProxy {
        guard let delegate = base.delegate as? CAAnimationDelegateProxy else {
            let proxy = CAAnimationDelegateProxy()
            base.delegate = proxy
            return proxy
        }
        return delegate
    }

    /// CAAnimation wrapper to avoid circular references.
    ///
    /// - Parameters:
    ///   - action: A closure that call back with you created `animation` instance when animation start.
    /// - Returns: Reer
    @discardableResult
    func onStart(_ action: @escaping (CAAnimation) -> Void) -> Self {
        delegateProxy.onStartActions.append(action)
        return self
    }

    /// ReerKit: CAAnimation wrapper to avoid circular references.
    ///
    /// - Parameters:
    ///   - action: A closure that call back with you created `animation` instance and `finished` flag when animation stop.
    /// - Returns: Reer
    @discardableResult
    func onStop(_ action: @escaping (CAAnimation, Bool) -> Void) -> Self {
        delegateProxy.onStopActions.append(action)
        return self
    }
}
