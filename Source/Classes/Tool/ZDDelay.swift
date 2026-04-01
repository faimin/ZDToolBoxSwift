//
//  ZDDelay.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/6/1.
//

import Foundation

// MARK: - ZDDelay

public struct ZDDelay {
    // MARK: Nested Types

    private final class Storage {
        var cache: [String: DispatchWorkItem] = [:]
        var lock = os_unfair_lock()
    }

    // MARK: Properties

    private let storage = Storage()

    // MARK: Lifecycle

    // MARK: - Public

    public init() {}

    // MARK: Functions

    /// Debounce: only the last invocation is executed.
    /// The callback runs on a background queue.
    ///
    /// - Parameters:
    ///   - key: Debounce key; calls with the same key override the previous task.
    ///   - delay: Delay in seconds.
    ///   - callback: Callback to execute after the delay.
    /// - Returns: The enqueued `DispatchWorkItem`.
    ///
    /// Example:
    /// ```swift
    /// var delay = ZDDelay()
    /// delay.debounce(key: "search", 0.3) {
    ///     print("perform search")
    /// }
    /// ```
    @discardableResult
    public mutating func debounce(
        key: String = "\(#fileID)-\(#function)-\(#line)",
        _ delay: TimeInterval,
        _ callback: @escaping os_block_t
    ) -> DispatchWorkItem {
        if let item = getItemFromDict(key) {
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

    /// Throttle: only the first invocation is executed within the throttle window.
    /// The callback runs on a background queue.
    ///
    /// - Parameters:
    ///   - key: Throttle key; the same key is ignored until the running task finishes.
    ///   - delay: Delay in seconds.
    ///   - callback: Callback to execute after the delay.
    ///
    /// Example:
    /// ```swift
    /// var delay = ZDDelay()
    /// delay.throttle(key: "tap", 0.5) {
    ///     print("submit once")
    /// }
    /// ```
    public mutating func throttle(
        key: String = "\(#fileID)-\(#function)-\(#line)",
        _ delay: TimeInterval,
        _ callback: @escaping os_block_t
    ) {
        guard getItemFromDict(key) == nil else {
            return
        }

        let storage = self.storage
        let workItem = DispatchWorkItem {
            os_unfair_lock_lock(&storage.lock)
            storage.cache[key] = nil
            os_unfair_lock_unlock(&storage.lock)
            callback()
        }
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + delay, execute: workItem)
        setItemToDict(key, workItem)
    }

    /// Cancels the scheduled task for the given key.
    ///
    /// - Parameter key: Task key.
    /// - Returns: `true` if a task existed and was canceled; otherwise `false`.
    ///
    /// Example:
    /// ```swift
    /// var delay = ZDDelay()
    /// _ = delay.cancel("search")
    /// ```
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
        os_unfair_lock_lock(&storage.lock)
        defer {
            os_unfair_lock_unlock(&storage.lock)
        }
        return storage.cache[key]
    }

    private mutating func setItemToDict(_ key: String, _ workItem: DispatchWorkItem?) {
        os_unfair_lock_lock(&storage.lock)
        storage.cache[key] = workItem
        os_unfair_lock_unlock(&storage.lock)
    }
}

public extension ZDDelay {
    /// Creates a cancelable delayed task on the main queue.
    ///
    /// - Parameters:
    ///   - delay: Delay in seconds.
    ///   - callback: Callback to execute after the delay.
    /// - Returns: A `DispatchWorkItem` that can be canceled.
    ///
    /// Example:
    /// ```swift
    /// let item = ZDDelay.delay(1.0) { print("run later") }
    /// item.cancel()
    /// ```
    @discardableResult
    static func delay(_ delay: TimeInterval, _ callback: @escaping os_block_t) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: callback)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
}
