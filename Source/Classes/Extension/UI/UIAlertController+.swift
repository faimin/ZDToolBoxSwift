//
//  UIAlertController+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/12/2.
//

import ObjectiveC
import UIKit

@MainActor private var ZD_UIAlertAction_Key: Void?

// MARK: - ZDActionModel

public struct ZDActionModel {
    // MARK: Properties

    let title: String
    let style: UIAlertAction.Style
    let tag: Int

    // MARK: Lifecycle

    /// Creates an action model for `showAlert`.
    ///
    /// - Parameters:
    ///   - title: Action title.
    ///   - style: Action style.
    ///   - tag: Custom identifier for click handling.
    ///
    /// Example:
    /// ```swift
    /// let ok = ZDActionModel(title: "OK", style: .default, tag: 1)
    /// ```
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

@MainActor
public extension ZDSWrapper where T: UIAlertController {
    /// Creates and presents an alert controller.
    ///
    /// - Parameters:
    ///     - containerController: Controller used to present the alert.
    ///     - actionModels: One or more action models.
    ///     - extraConfig: Optional configuration callback, e.g. adding text fields.
    ///     - completion: Completion callback after presenting.
    ///     - clickHandler: Action tap callback; use `tag` to identify which action was tapped.
    ///
    /// - Returns: UIAlertController
    ///
    /// Example:
    /// ```swift
    /// UIAlertController.zd.showAlert(
    ///     self,
    ///     preferredStyle: .alert,
    ///     title: "Tips",
    ///     message: "Saved",
    ///     actionModels: ZDActionModel(title: "OK", style: .default, tag: 1),
    ///     extraConfig: nil,
    ///     completion: nil
    /// ) { _, tag in
    ///     print(tag)
    /// }
    /// ```
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
