//
//  ZDChainCallerTests.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero.D.Saber on 2025/5/15.
//

import Testing
import UIKit
@testable import ZDToolBoxSwift

struct ZDChainCallerTests {
    @Test
    @MainActor
    func chain() {
        let label: UILabel = UILabel()
            .chain
            .font(.boldSystemFont(ofSize: 10))
            .text("hello world")
            .textAlignment(.center)
        
        #expect(label.text == "hello world")
        #expect(label.textAlignment == .center)
    }
}
