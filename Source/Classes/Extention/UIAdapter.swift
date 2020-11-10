//
//  UIAdapter.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit

public struct UIAdapter {
    
    //屏蔽掉初始化方法
    private init() {}
    
    //MARK: - 安全区域
    private static var safeAreaInsets: UIEdgeInsets = {
        guard #available(iOS 11.0, *) else {
            return UIEdgeInsets.zero
        }
        
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
    }()
    
    //MARK: - 计算属性
    public static var safeAreaTopMargin: CGFloat {
        safeAreaInsets.top
    }
    
    public static var safeAreaBottomMargin: CGFloat {
        safeAreaInsets.bottom
    }
    
}
