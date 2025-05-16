//
//  ZDDelayTests.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero.D.Saber on 2025/5/16.
//

import Testing
@testable import ZDToolBoxSwift

struct ZDDelayTests {
    @Test
    func debouds() {
        var x = ZDDelay()
        for i in 0 ... 100_000 {
            x.debounce(0.05) {
                print("debounce = ", Thread.current, i)
            }
        }
    }

    @Test
    func throttle() {
        var x = ZDDelay()
        for i in 0 ... 100_000 {
            x.throttle(0.05) {
                print("throttle = ", Thread.current, i)
            }
        }
    }
    
    func substr() {
        //let str = "你好,我是小明: 0123456789"
        //let res = str.zd.substring(maxLength: 5, addEllipsis: true)
        //#expect(res == "你好,我是...")
    }
}
