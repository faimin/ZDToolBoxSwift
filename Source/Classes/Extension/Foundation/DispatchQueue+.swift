//
//  DispatchQueue+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import Foundation

public extension ZDSWraper where T == DispatchQueue {
    private static var _onceTracker = Set<String>()

    static func once(
        token: String,
        block: os_block_t
    ) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }

        guard !_onceTracker.contains(token) else {
            return
        }
        _onceTracker.insert(token)
        block()
    }

    static func once(
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        block: os_block_t
    ) {
        let token = "\(file):\(function):\(line)"
        once(token: token, block: block)
    }
}
