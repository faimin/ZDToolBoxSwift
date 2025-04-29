//
//  CAAnimation+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2024/10/26.
//

import Foundation

public typealias ZDCADidStartBlock = (CAAnimation) -> Void
public typealias ZDCADidStopBlock = (CAAnimation, Bool) -> Void

private final class CAAnimationDelegateMediator: NSObject, CAAnimationDelegate {
    fileprivate var startBlock: ZDCADidStartBlock?
    fileprivate var stopBlock: ZDCADidStopBlock?

    // MARK: - CAAnimationDelegate

    func animationDidStart(_ anim: CAAnimation) {
        startBlock?(anim)
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopBlock?(anim, flag)
    }
}

public extension ZDSWraper where T: CAAnimation {
    func animationDidStart(_ block: @escaping ZDCADidStartBlock) {
        guard let delegate = base.delegate as? CAAnimationDelegateMediator else {
            let delegateMediator = CAAnimationDelegateMediator()
            delegateMediator.startBlock = block
            base.delegate = delegateMediator // retain
            return
        }
        delegate.startBlock = block
    }

    func animationDidStop(_ block: @escaping ZDCADidStopBlock) {
        guard let delegate = base.delegate as? CAAnimationDelegateMediator else {
            let delegateMediator = CAAnimationDelegateMediator()
            delegateMediator.stopBlock = block
            base.delegate = delegateMediator // retain
            return
        }
        delegate.stopBlock = block
    }
}
