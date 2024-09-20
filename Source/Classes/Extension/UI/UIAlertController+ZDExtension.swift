//
//  UIAlertController+ZDExtension.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/12/2.
//

import ObjectiveC
import UIKit

private var ZD_UIAlertAction_Key: Void?

public struct ZDActionModel {
    let title: String
    let style: UIAlertAction.Style
    let tag: Int

    public init(
        title: String,
        style: UIAlertAction.Style,
        tag: Int
    ) {
        self.title = title
        self.style = style
        self.tag = tag
    }
}

public extension ZDSWraper where T: UIAlertController {
    /// 便捷创建Alert弹窗
    ///
    /// - Parameters:
    ///     - containerController: 在哪个控制器页面弹出
    ///     - actionModels: 按钮model，可以传递多个
    ///     - extraConfig: 设置额外参数的回调，比如可以在此添加输入框
    ///     - completion: 弹出后的回调
    ///     - clickHandler: 点击按钮时的回调，通过tag来判断点击的是哪个按钮
    ///
    /// - Returns: UIAlertController
    @discardableResult
    static func showAlert(
        _ containerController: UIViewController,
        preferredStyle: T.Style,
        title: String?,
        message: String?,
        actionModels: ZDActionModel...,
        extraConfig: ((T) -> Void)?,
        completion: (() -> Void)?,
        clickHandler: ((UIAlertAction, Int) -> Void)?
    ) -> T {
        let alertController = T(title: title, message: message, preferredStyle: preferredStyle)

        for model in actionModels {
            let action = UIAlertAction(title: model.title, style: model.style) { a in
                let actionTag = objc_getAssociatedObject(a, &ZD_UIAlertAction_Key) as? Int ?? 0
                clickHandler?(a, actionTag)
            }
            objc_setAssociatedObject(action, &ZD_UIAlertAction_Key, model.tag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            alertController.addAction(action)
        }

        extraConfig?(alertController)

        containerController.present(alertController, animated: true, completion: completion)

        return alertController
    }
}
