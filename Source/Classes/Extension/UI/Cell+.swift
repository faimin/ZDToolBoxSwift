//
//  Cell+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import UIKit

// MARK: - ZDSCellProtocol

public protocol ZDSCellProtocol: AnyObject {
    associatedtype T

    /// cell重用id
    static var reuseIdentifier: String { get }

    /// 绑定数据
    func bindModel(_ model: T)
}

public extension ZDSCellProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    func bindModel(_: T) {
        debugPrint("ZDSCellProtocol -> \(#function) 默认实现")
    }
}

// MARK: - UITableViewCell + ZDSCellProtocol

extension UITableViewCell: ZDSCellProtocol {
    public typealias T = Any
}

// MARK: - UICollectionReusableView + ZDSCellProtocol

extension UICollectionReusableView: ZDSCellProtocol {
    public typealias T = Any
}
