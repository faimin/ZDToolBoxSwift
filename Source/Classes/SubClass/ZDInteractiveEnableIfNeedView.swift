//
//  ZDInteractiveEnableIfNeedView.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/10/30.
//
//  视图上如果没有子视图则不响应事件
//  有子视图的时候只响应子视图占用的部分响应事件，其他部分默认不响应
//  如果想让空白部分响应，有2中方式：一是让子视图占满全屏，二是开启`isBlankAreaResponse`属性

import UIKit

class ZDInteractiveEnableIfNeedView: UIControl {
    /// 是否让空白区域响应点击事件
    /// 默认不响应，直接透传到下面的层级
    @objc public var isBlankAreaResponse = false
    
#if false
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 不可交互、隐藏、alpha <= 0.01 都不响应
        guard isUserInteractionEnabled && !isHidden && alpha > 0.01 else {
            return nil
        }

        // 点击位置不在当前视图内不响应
        guard self.point(inside: point, with: event) else {
            return nil
        }

        // 没有子视图时，不响应
        let tempSubViews = subviews
        guard !tempSubViews.isEmpty else {
            return nil
        }

        for view in tempSubViews.reversed() {
            // 把当前视图上的坐标点转换为在子视图坐标系上的坐标点
            let pointInSubViewSystem = convert(point, to: view)
            // 事件传递给子视图
            let hitTestView = view.hitTest(pointInSubViewSystem, with: event)
            if hitTestView != nil {
                return hitTestView
            }
        }

        // 如果想让空白区域响应，只需要调用super方法即可
        guard isBlankAreaResponse else {
            return nil
        }

        return super.hitTest(point, with: event)
    }
    
#else
    
    // https://github.com/mastodon/mastodon-ios/blob/311bbc0/MastodonSDK/Sources/MastodonUI/View/Container/TouchTransparentStackView.swift
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self, !isBlankAreaResponse {
            return nil
        }
        return view
    }
#endif
}
