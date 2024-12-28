//
//  ZDExpandClickAreaView.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/11/6.
//
//  默认让超出父视图的部分也响应点击事件

import UIKit

public class ZDExpandClickAreaView: UIView {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 不可交互、隐藏、alpha <= 0.01 都不响应
        guard isUserInteractionEnabled && !isHidden && alpha > 0.01 else {
            return nil
        }

        for view in subviews.reversed() {
            // 把当前视图上的坐标点转换为在子视图坐标系上的坐标点
            let pointInSubViewSystem = convert(point, to: view)
            // 如果坐标点在子视图内，则执行子视图的hitTest
            if view.bounds.contains(pointInSubViewSystem) {
                return view.hitTest(pointInSubViewSystem, with: event)
            }
        }

        return super.hitTest(point, with: event)
    }
}
