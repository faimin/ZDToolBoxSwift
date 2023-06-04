//
//  ZDSwiftFunction.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2020/11/23.
//

import Foundation

// https://twitter.com/johnsundell/status/1055562781070684162
public func combine<A, B>(_ value: A, with closure: @escaping (A) -> B) -> () -> B {
    return { closure(value) }   // <==> { () in closure(value) }
}
