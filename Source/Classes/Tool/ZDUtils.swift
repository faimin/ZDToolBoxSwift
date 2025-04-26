//
//  ZDUtils.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2022/4/14.
//

import Foundation

public struct ZDUtils {}

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

public extension ZDUtils {
    /// Usage:
    ///
    ///     let needUpgrade = ZDUtils.compareVersions(v1, v2) == .orderedDescending // v1 > v2
    ///
    static func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let components1 = version1.components(separatedBy: CharacterSet(charactersIn: ".-_"))
        let components2 = version2.components(separatedBy: CharacterSet(charactersIn: ".-_"))

        let maxLength = max(components1.count, components2.count)

        let components1Count = components1.count
        let components2Count = components2.count
        for i in 0 ..< maxLength {
            let part1 = i < components1Count ? Int(components1[i]) ?? 0 : 0
            let part2 = i < components2Count ? Int(components2[i]) ?? 0 : 0

            if part1 == part2 {
                continue
            } else if part1 < part2 {
                return .orderedAscending
            } else if part1 > part2 {
                return .orderedDescending
            }
        }

        return .orderedSame
    }
}
