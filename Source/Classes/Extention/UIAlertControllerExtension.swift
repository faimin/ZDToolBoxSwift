//
//  UIAlertControllerExtension.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2020/12/2.
//

import UIKit
import ObjectiveC

public struct MMActionModel {
    let title: String
    let style: UIAlertAction.Style
    let tag: Int
}

extension UIAlertController {
    private static var ZD_UIAlertAction_Key: Void?
    
    @discardableResult
    public class func showAlert(in containerController: UIViewController, preferredStyle: Style, title: String?, message: String?, actionModels: MMActionModel..., extraConfig: ((UIAlertController) -> Void)?, completion: (() -> Void)?, clickHandler: ((UIAlertAction, Int) -> Void)?) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        for model in actionModels {
            let action = UIAlertAction(title: model.title, style: model.style) { (a) in
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

