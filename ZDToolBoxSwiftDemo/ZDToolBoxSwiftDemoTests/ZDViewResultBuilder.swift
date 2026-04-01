//
//  ZDViewResultBuilder.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero_D_Saber on 2025/12/5.
//

import Testing
import UIKit
@testable import ZDToolBoxSwift

struct ZDViewResultBuilder {}

extension ZDViewResultBuilder {
    @Test("test view builder")
    @MainActor
    func resultBuilder() {
        let container = UIView()
        
        let aView = {
            let v = UIView()
            v.backgroundColor = .red
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        container.addSubview(aView)
        
        var centerConstraint: NSLayoutConstraint?
        centerConstraint = nil //Fix warning
        let a = 1
        let b = 2
        NSLayoutConstraint.zd.activate {
            if a > b {
                aView.widthAnchor.constraint(equalToConstant: 100)
            } else if a < b {
                aView.widthAnchor.constraint(equalToConstant: 200)
            } else {
                aView.widthAnchor.constraint(equalToConstant: 300)
            }
            
            switch b {
            case 1: aView.heightAnchor.constraint(equalToConstant: 200)
            default: aView.heightAnchor.constraint(equalToConstant: 300)
            }
            
            aView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            
            for _ in (0..<1) {
                aView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            }
            
            if let centerConstraint {
                centerConstraint
            }
            
            if #available(iOS 15.0, *) {
                centerConstraint
            }
        }
    }
}
