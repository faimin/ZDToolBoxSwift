//
//  ZDDelayTests.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero.D.Saber on 2025/5/16.
//

import Testing
import UIKit
@testable import ZDToolBoxSwift

struct ZDDelayTests {
    @Test
    func debounceOnlyExecutesLastCallback() {
        var delay = ZDDelay()
        let semaphore = DispatchSemaphore(value: 0)
        var callbackCount = 0

        for _ in 0..<10 {
            delay.debounce(key: "debounce-key", 0.02) {
                callbackCount += 1
                semaphore.signal()
            }
        }

        #expect(semaphore.wait(timeout: .now() + 1.0) == .success)
        #expect(callbackCount == 1)
    }

    @Test
    func throttleCanExecuteAgainAfterPreviousCallbackFinished() {
        var delay = ZDDelay()
        let semaphore = DispatchSemaphore(value: 0)
        var callbackCount = 0

        delay.throttle(key: "throttle-key", 0.02) {
            callbackCount += 1
            semaphore.signal()
        }
        #expect(semaphore.wait(timeout: .now() + 1.0) == .success)

        delay.throttle(key: "throttle-key", 0.02) {
            callbackCount += 1
            semaphore.signal()
        }
        #expect(semaphore.wait(timeout: .now() + 1.0) == .success)

        #expect(callbackCount == 2)
    }

    @Test
    @MainActor
    func viewWrapperYReflectsFrameOriginY() {
        let view = UIView(frame: CGRect(x: 11, y: 22, width: 100, height: 40))
        #expect(view.zd.y == 22)
    }
}
