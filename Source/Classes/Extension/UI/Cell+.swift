//
//  Cell+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import UIKit

// MARK: - ZDSCellProtocol

public protocol ZDSCellProtocol: AnyObject {
    func bindModel<T>(_ model: T)
}

public extension ZDSCellProtocol {
    func bindModel<T>(_: T) {
        debugPrint("ZDSCellProtocol -> \(#function)'s default implication")
    }
}

// MARK: - UITableViewCell + ZDSCellProtocol

extension UITableViewCell: ZDSCellProtocol {}

// MARK: - UICollectionReusableView + ZDSCellProtocol

extension UICollectionReusableView: ZDSCellProtocol {}

public extension ZDSWraper where T: ZDSCellProtocol {
    static var reuseIdentifier: String {
        String(describing: T.self)
    }
}
