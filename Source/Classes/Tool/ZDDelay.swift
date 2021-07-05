//
//  ZDDelay.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/6/1.
//

import Foundation

public struct ZDDelay {
    
    private lazy var _zdFuncCache: [String: DispatchWorkItem] = [:]
    private lazy var _lock = os_unfair_lock()
    
    // MARK: - Public
    
    public init() {
        
    }
    
    /// 防抖：只执行最后一次
    /// 最终任务是在子线程执行
    @discardableResult
    public mutating func debounce(_ key: String = "\(#file)-\(#function)-\(#line)", _ delay: TimeInterval, _ callback: @escaping os_block_t) -> DispatchWorkItem {
        
        if let item = _zdFuncCache[key] {
            if !item.isCancelled {
                item.cancel()
            }
            setItemToDict(key, nil)
        }
        
        let workItem = DispatchWorkItem(block: callback)
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delay, execute: workItem)
        
        setItemToDict(key, workItem)
        
        return workItem
    }
    
    /// 节流：只执行第一次
    /// 最终任务是在子线程执行
    public mutating func throttle(_ key: String = "\(#file)-\(#function)-\(#line)", _ delay: TimeInterval, _ callback: @escaping os_block_t) {
        
        guard getItemFromDict(key) == nil else {
            return
        }
        
        var mutatingSelf = self
        let workItem = DispatchWorkItem {
            callback()
            mutatingSelf.setItemToDict(key, nil)
        }
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delay, execute: workItem)
        setItemToDict(key, workItem)
    }
    
    /// 取消
    @discardableResult
    public mutating func cancel(_ key: String) -> Bool {
        
        guard let item = getItemFromDict(key) else {
            return false
        }
        
        if !item.isCancelled {
            item.cancel()
        }
        setItemToDict(key, nil)
        
        return true
    }

    // MARK: - Private
    
    private mutating func getItemFromDict(_ key: String) -> DispatchWorkItem? {
        
        os_unfair_lock_lock(&_lock)
        defer {
            os_unfair_lock_unlock(&_lock)
        }
        return _zdFuncCache[key]
    }
    
    private mutating func setItemToDict(_ key: String, _ workItem: DispatchWorkItem?) {
        
        os_unfair_lock_lock(&_lock)
        _zdFuncCache[key] = workItem
        os_unfair_lock_unlock(&_lock)
    }
}


public extension ZDDelay {
    
    /// 支持取消的延迟函数
    @discardableResult
    static func delay(_ delay: TimeInterval, _ callback: @escaping os_block_t) -> DispatchWorkItem {
        
        let workItem = DispatchWorkItem(block: callback)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
}
