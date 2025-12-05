//
//  ViewController.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit
import ZDToolBoxSwift

class ZDLayoutGuide: UILayoutGuide {
    override func _updateLayoutFrame(inOwningView arg1: Any!, fromEngine arg2: Any!) {
        super._updateLayoutFrame(inOwningView: arg1, fromEngine: arg2)
        
        print("22222----> ", layoutFrame)
    }
}

class ZDGradientLabel: UILabel {
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .lightText
        
        let label = ZDGradientLabel()
        let l = label.layer
        print(l)
        
        let _ = ZDExcuteSymbol()
        
        let layout = ZDLayoutGuide()
        self.view.addLayoutGuide(layout)
        NSLayoutConstraint.activate([
            layout.widthAnchor.constraint(equalTo: view.widthAnchor),
            layout.heightAnchor.constraint(equalTo: view.heightAnchor),
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 13.0, *) {
            Task {
                await self.foo()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension ViewController {
    @ZDGloableActor
    func foo() {
        debugPrint(#function)
    }
}

@available(iOS 17.0, *)
#Preview(traits: .defaultLayout) {
    ViewController()
}
