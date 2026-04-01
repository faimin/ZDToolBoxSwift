//
//  UIAdapter.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit

@MainActor
public enum UIAdapter {
    // MARK: Static Properties

    /// Best-effort key window snapshot.
    ///
    /// Example:
    /// ```swift
    /// let window = UIAdapter.window
    /// ```
    public static var window: UIWindow = {
        let window = UIApplication.zd.keyWindow ?? UIWindow()
        return window

        /*
         let application = UIApplication.shared
         if let delegeWindow = application.delegate?.window, let delegeWindow = delegeWindow {
             return delegeWindow
         }

         guard #available(iOS 13.0, tvOS 13.0, *) else {
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
          */
    }()

    // MARK: - Safe Area

    /// Cached safe area insets from `window`.
    ///
    /// Example:
    /// ```swift
    /// let insets = UIAdapter.safeAreaInsets
    /// ```
    public static var safeAreaInsets: UIEdgeInsets = {
        guard #available(iOS 11.0, *) else {
            return UIEdgeInsets.zero
        }

        return Self.window.safeAreaInsets
    }()

    // MARK: Static Computed Properties

    /// Safe area top inset.
    public static var safeAreaTopMargin: CGFloat {
        safeAreaInsets.top
    }

    /// Safe area bottom inset.
    public static var safeAreaBottomMargin: CGFloat {
        safeAreaInsets.bottom
    }

    // MARK: Static Functions

    /// Returns safe-area top inset if available, otherwise returns `defaultMargin`.
    ///
    /// Example:
    /// ```swift
    /// let top = UIAdapter.safeAreaTopMargin(defaultMargin: 20)
    /// ```
    public static func safeAreaTopMargin(defaultMargin: CGFloat) -> CGFloat {
        guard safeAreaInsets.top > 0 else {
            return defaultMargin
        }
        return safeAreaInsets.top
    }

    /// Returns safe-area bottom inset if available, otherwise returns `defaultMargin`.
    ///
    /// Example:
    /// ```swift
    /// let bottom = UIAdapter.safeAreaBottomMargin(defaultMargin: 0)
    /// ```
    public static func safeAreaBottomMargin(defaultMargin: CGFloat) -> CGFloat {
        guard safeAreaBottomMargin > 0 else {
            return defaultMargin
        }
        return safeAreaBottomMargin
    }

    /// Returns width scaled against a 375pt reference screen (iPhone 6).
    ///
    /// Example:
    /// ```swift
    /// let width = UIAdapter.rem375(120)
    /// ```
    public static func rem375(_ value: CGFloat) -> CGFloat {
        return (UIScreen.main.bounds.width / 375.0) * value
    }
}
