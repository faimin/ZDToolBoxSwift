//
//  ZDUtils.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2022/4/14.
//

import Foundation

@objc public final class ZDUtils : NSObject {
    
    /// See http://developer.apple.com/library/mac/#qa/qa1361/_index.html
    /// 是否处于调试状态
    @objc public class func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0)
        let isDebuggerAttaced = info.kp_proc.p_flag & P_TRACED != 0
        return isDebuggerAttaced
    }
    
}
