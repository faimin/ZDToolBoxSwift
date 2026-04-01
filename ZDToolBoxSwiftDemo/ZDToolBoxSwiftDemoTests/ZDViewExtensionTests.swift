//
//  ZDViewExtensionTests.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero_D_Saber on 2025/12/8.
//

import Testing
import UIKit
import ZDToolBoxSwift

@MainActor
struct ZDViewExtensionTests {
    @Test
    func findConstraint() {
        let container = UIView()
        
        let aView = UIView()
        aView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(aView)
        
        aView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        aView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        let leadingConstraint = aView.leadingAnchor.constraint(equalTo: container.leadingAnchor)
        leadingConstraint.isActive = true
        
        let lc = aView.zd.findConstraint(attribute: .leading, relation: .equal)
        #expect(leadingConstraint == lc)
    }
}
