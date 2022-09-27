//
//  ViewController.swift
//  ZDSwiftToolKitDemo
//
//  Created by Zero.D.Saber on 2020/11/10.
//

import UIKit
import ZDSwiftToolKit
import os

/// 函数签名要一一对应，否则会转换失败 @convention(thin) 也不用能缺了
typealias F = @convention(thin) (_ params: [String: Any]) -> [String: Any]?

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
        os_log("error", dso: rw.dso, log: rw.log, type: .fault)
        os_log(.fault, dso: rw.dso, log: rw.log, "aaaaa", "vvv")
        */
        let symbol = FindSymbolAddress("ZD://login")
        let f = unsafeBitCast(symbol, to: F.self)
        let _ = f(["navi": "Zero.D.Saber"])
        print(symbol ?? "-------")
    }
}

@_silgen_name("ZD://login")
public func LoginRouterInterface(with params: [String: Any]) -> [String: Any]? {
    guard let navi = params["navi"] else {
       return nil
    }
    print(navi)
    
    return nil
}
