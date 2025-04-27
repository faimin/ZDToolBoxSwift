//
//  ViewController.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit
import ZDToolBoxSwift

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let _ = ZDExcuteSymbol()
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
