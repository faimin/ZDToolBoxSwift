//
//  NSCollectionLayoutGroup+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/5.
//

import UIKit

@available(iOS 13.0, *)
@MainActor
public extension ZDSWrapper where T: NSCollectionLayoutGroup {
    static func horizontal(
        layoutSize: NSCollectionLayoutSize,
        repeatingSubitem subitem: NSCollectionLayoutItem,
        count: Int
    ) -> NSCollectionLayoutGroup {
        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                repeatingSubitem: subitem,
                count: count
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: subitem, count: count)
        }
        return group
    }

    static func vertical(
        layoutSize: NSCollectionLayoutSize,
        repeatingSubitem subitem: NSCollectionLayoutItem,
        count: Int
    ) -> NSCollectionLayoutGroup {
        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.vertical(
                layoutSize: layoutSize,
                repeatingSubitem: subitem,
                count: count
            )
        } else {
            group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: subitem, count: count)
        }
        return group
    }
}
