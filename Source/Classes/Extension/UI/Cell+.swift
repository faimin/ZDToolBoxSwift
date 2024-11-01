//
//  Cell+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/5/31.
//

import UIKit

public protocol ZDSCellProtocol: AnyObject {
    associatedtype T

    /// cell重用id
    static func cellIdentifier() -> String

    /// 绑定数据
    func bindModel(_ model: T)
}

public extension ZDSCellProtocol {
    static func cellIdentifier() -> String {
        return "\(Self.self)"
    }

    func bindModel(_: T) {
        print("ZDSCellProtocol -> \(#function) 默认实现")
    }
}

extension UITableViewCell: ZDSCellProtocol {
    public typealias T = Any
}

extension UICollectionViewCell: ZDSCellProtocol {
    public typealias T = Any
}
