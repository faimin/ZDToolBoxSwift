//
//  ZDUtils.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2022/4/14.
//

import Foundation

@objc
public final class ZDUtils: NSObject {
    /// See http://developer.apple.com/library/mac/#qa/qa1361/_index.html
    /// 是否处于调试状态
    @objc
    public static func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0)
        let isDebuggerAttaced = info.kp_proc.p_flag & P_TRACED != 0
        return isDebuggerAttaced
    }
}

public extension ZDUtils {
    enum Environment {
        case debug
        case testFlight
        case appStore
    }

    static var appPublishEnv: Environment {
        #if DEBUG
            return .debug
        #elseif targetEnvironment(simulator)
            return .debug
        #else
            if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
                return .testFlight
            }

            guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
                return .debug
            }

            if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
                return .testFlight
            }

            if appStoreReceiptUrl.path.lowercased().contains("simulator") {
                return .debug
            }

            return .appStore
        #endif
    }
}
