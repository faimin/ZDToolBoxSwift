//
//  ZDExcuteSymbol.swift
//  ZDSwiftToolKitDemo
//
//  Created by Zero.D.Saber on 2022/10/10.
//

import Foundation
import ZDSwiftToolKit
import os

/// 函数签名要一一对应，否则会转换失败 @convention(thin) 也不能缺了
typealias F = @convention(thin) (_ params: [String: Any]) -> [String: Any]?

class ZDExcuteSymbol {
    
    init() {
        excute()
    }
    
    private final func excute() {
        /*
        os_log("error", dso: rw.dso, log: rw.log, type: .fault)
        os_log(.fault, dso: rw.dso, log: rw.log, "aaaaa", "vvv")
        */
        let symbol = ZDSymbolIMP.FindSymbolAddress("ZD://login")
        let f = unsafeBitCast(symbol, to: F.self)
        let _ = f(["navi": "Zero.D.Saber"])
        print(symbol ?? "-------")
    }
    
    @_silgen_name("ZD://login")
    public func LoginRouterInterface(with params: [String: Any]) -> [String: Any]? {
        guard let navi = params["navi"] else {
           return nil
        }
        print(navi)
        
        return nil
    }

}




