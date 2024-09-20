//
//  ZDBreakpoint.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2022/1/4.
//
//  https://www.pointfree.co/blog/posts/70-unobtrusive-runtime-warnings-for-libraries

#if DEBUG
import os

//@available(iOS 10.0, *)
//@inline(__always)
//public func zdbreakpoint() {
//    var info = Dl_info()
//    dladdr(
//        dlsym(
//            dlopen("", RTLD_LAZY),
//            "$s10Foundation15AttributeScopesO7SwiftUIE05swiftE0AcDE0D12UIAttributesVmvg"
//        ),
//        &info
//    )
//
//    os_log("zd-fatal", dso: info.dli_fbase, log: OSLog(subsystem: "com.zd.issue", category: "zd"), type: .fault)
//}


//public let rw = (
//    dso: { () -> UnsafeMutableRawPointer in
//      var info = Dl_info()
//      dladdr(dlsym(dlopen(nil, RTLD_LAZY), "LocalizedString"), &info)
//      return info.dli_fbase
//    }(),
//    log: OSLog(subsystem: "com.apple.runtime-issues", category: "ComposableArchitecture")
//  )
#endif
