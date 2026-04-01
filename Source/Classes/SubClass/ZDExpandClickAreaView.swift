//
//  ZDExpandClickAreaView.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/11/6.
//
//  Allows touch handling even for subview areas outside parent bounds by default.

import UIKit

public class ZDExpandClickAreaView: UIView {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Ignore touches when disabled/hidden/almost transparent.
        guard isUserInteractionEnabled, !isHidden, alpha > 0.01 else {
            return nil
        }

        for view in subviews.reversed() {
            // Convert touch point to subview coordinate space.
            let pointInSubViewSystem = convert(point, to: view)
            // If point is inside subview bounds, run subview hit-testing.
            if view.bounds.contains(pointInSubViewSystem) {
                return view.hitTest(pointInSubViewSystem, with: event)
            }
        }

        return super.hitTest(point, with: event)
    }
}
