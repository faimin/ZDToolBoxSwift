//
//  CellExtensionTests.swift
//  ZDToolBoxSwiftDemo
//
//  Created by Zero_D_Saber on 2025/12/5.
//

import Testing
import UIKit
@testable import ZDToolBoxSwift

@MainActor
struct CellExtensionTests {}

extension CellExtensionTests {
    class CollectionCellOne: UICollectionViewCell {
        func bindModel(_ model: [String: Any]) {
            debugPrint("\(#function)")
            #expect(model["name"] as? String == "Zero.D.Saber")
        }
    }
    
    @Test("get cell reuseid")
    func cellReuseId() {
        #expect(CollectionCellOne.zd.reuseIdentifier == "CollectionCellOne")
        
        CollectionCellOne().bindModel(["name": "Zero.D.Saber"])
    }
}
