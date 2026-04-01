//
//  Optional+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/18.
//

// MARK: - Optional + ZDSGenericAny

extension Optional: ZDSGenericAny {
    public typealias T1 = Wrapped
}

public extension ZDSGenericWrapper where T == T1? {
    var isNil: Bool {
        base == nil
    }

    var isNotNil: Bool {
        !isNil
    }
}

public extension ZDSGenericWrapper where T == T1?, T1: Collection {
    var isEmpty: Bool {
        guard let collection = base else {
            return true
        }
        return collection.isEmpty
    }

    var isNotEmpty: Bool {
        !isEmpty
    }
}

public extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        zd.isEmpty
    }

    var isNonEmpty: Bool {
        !isEmpty
    }
}
