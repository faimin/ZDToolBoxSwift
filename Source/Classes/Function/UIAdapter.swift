//
//  UIAdapter.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit

public enum UIAdapter {
    
    public static var window: UIWindow = {
        let application = UIApplication.shared
        if let delegeWindow = application.delegate?.window, let delegeWindow = delegeWindow {
            return delegeWindow
        }
        
        guard #available(iOS 13.0, *) else {
            let keyWindow = application.keyWindow ?? UIWindow()
            return keyWindow
        }
        
        for scene in application.connectedScenes where scene is UIWindowScene {
            guard let windowSceneDelete = scene.delegate as? UIWindowSceneDelegate, let window = windowSceneDelete.window, let window = window else {
                continue
            }
            return window
        }
        
        let mainWindow = application.windows.first ?? UIWindow()
        return mainWindow
    }()
    
    // MARK: - 安全区域
    public static var safeAreaInsets: UIEdgeInsets = {
        guard #available(iOS 11.0, *) else {
            return UIEdgeInsets.zero
        }
        
        return Self.window.safeAreaInsets
    }()
    
    // MARK: - 计算属性
    public static var safeAreaTopMargin: CGFloat {
        safeAreaInsets.top
    }
    
    public static var safeAreaBottomMargin: CGFloat {
        safeAreaInsets.bottom
    }
    
    /// 如果是刘海屏就返回刘海顶部，否则返回默认值
    public static func safeAreaTopMargin(defaultMargin: CGFloat) -> CGFloat {
        guard safeAreaInsets.top > 0 else {
            return defaultMargin
        }
        return safeAreaInsets.top
    }
    
    /// 如果是刘海屏就返回刘海底部，否则返回默认值
    public static func safeAreaBottomMargin(defaultMargin: CGFloat) -> CGFloat {
        guard safeAreaBottomMargin > 0 else {
            return defaultMargin
        }
        return safeAreaBottomMargin
    }
    
    /// 以iPhone6为比例的适配宽度
    public static func scaleValue(_ value:CGFloat) -> CGFloat {
        return (UIScreen.main.bounds.width/375) * value
    }
    
}
