//
//  ViewController.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit
import ZDToolBoxSwift

class ViewController: UIViewController {
    @IBOutlet weak var aV: UIView!
    
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

private extension ViewController {
    @objc
    @IBAction func fold(_ sender: UIButton) {
        print(#function)
        #if false
        aV.zd.fold(sender.isSelected)
        #endif
        sender.isSelected.toggle()
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
