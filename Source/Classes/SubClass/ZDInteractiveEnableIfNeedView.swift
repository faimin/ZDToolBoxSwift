//
//  ZDInteractiveEnableIfNeedView.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/10/30.
//
//  If there are no subviews, this view does not handle touch events.
//  When subviews exist, only occupied subview areas handle touches by default.
//  To make blank area tappable: either make a subview fill the bounds, or enable `isBlankAreaResponse`.

import UIKit

public class ZDInteractiveEnableIfNeedView: UIControl {
    // MARK: Properties

    /// Whether blank areas should respond to touches.
    /// Default is `false`, so touches pass through to underlying views.
    @objc public var isBlankAreaResponse = false

    // MARK: Overridden Functions

    #if false
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Ignore touches when disabled/hidden/almost transparent.
        guard isUserInteractionEnabled, !isHidden, alpha > 0.01 else {
            return nil
        }

        // Ignore touches outside current bounds.
        guard self.point(inside: point, with: event) else {
            return nil
        }

        // Ignore touches if there are no subviews.
        let tempSubViews = subviews
        guard !tempSubViews.isEmpty else {
            return nil
        }

        for view in tempSubViews.reversed() {
            // Convert touch point to subview coordinate space.
            let pointInSubViewSystem = convert(point, to: view)
            // Forward hit-testing to subview.
            let hitTestView = view.hitTest(pointInSubViewSystem, with: event)
            if hitTestView != nil {
                return hitTestView
            }
        }

        // If blank areas should be tappable, return `super.hitTest`.
        guard isBlankAreaResponse else {
            return nil
        }

        return super.hitTest(point, with: event)
    }

    #else

    /// https://github.com/mastodon/mastodon-ios/blob/311bbc0/MastodonSDK/Sources/MastodonUI/View/Container/TouchTransparentStackView.swift
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self, !isBlankAreaResponse {
            return nil
        }
        return view
    }
    #endif
}
