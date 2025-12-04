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
        
        resultBuilder()
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
    func resultBuilder() {
        let aView = {
            let v = UIView()
            v.backgroundColor = .red
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        view.addSubview(aView)
        
        var centerConstraint: NSLayoutConstraint?
        let a = 1
        let b = 2
        NSLayoutConstraint.activate {
            if a > b {
                aView.widthAnchor.constraint(equalToConstant: 100)
            } else if a < b {
                aView.widthAnchor.constraint(equalToConstant: 200)
            } else {
                aView.widthAnchor.constraint(equalToConstant: 300)
            }
            
            switch b {
            case 1: aView.heightAnchor.constraint(equalToConstant: 200)
            default: aView.heightAnchor.constraint(equalToConstant: 300)
            }
            
            aView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            aView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
            if let centerConstraint {
                centerConstraint
            }
            
            if #available(iOS 15.0, *) {
                centerConstraint
            }
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
