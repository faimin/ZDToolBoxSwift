//
//  NSObject+Combine.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/1/21.
//

import Combine
import Foundation
import ObjectiveC.runtime

// MARK: - AssociateKey

private nonisolated enum AssociateKey {
    nonisolated(unsafe) static var disposeBag: Void?
}

// MARK: - AssociateValueBox

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
private final class AssociateValueBox {
    private var disposeBag = Set<AnyCancellable>()
    private let lock = NSRecursiveLock()

    deinit {
        cancelAndRemoveAll()
    }

    func insert(_ cancellable: AnyCancellable) {
        lock.lock(); defer { lock.unlock() }
        disposeBag.insert(cancellable)
    }

    func cancelAndRemoveAll() {
        let cancellables: Set<AnyCancellable>
        lock.lock()
        cancellables = disposeBag
        disposeBag.removeAll()
        lock.unlock()
        cancellables.forEach { $0.cancel() }
    }

    func get() -> Set<AnyCancellable> {
        lock.lock(); defer { lock.unlock() }
        return disposeBag
    }

    func set(_ newValue: Set<AnyCancellable>) {
        lock.lock(); defer { lock.unlock() }
        disposeBag = newValue
    }
}

// MARK: - NSObject + Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ZDSWrapper where T: NSObject {
    private var box: AssociateValueBox {
        if let box = objc_getAssociatedObject(base, &AssociateKey.disposeBag) as? AssociateValueBox {
            return box
        }
        let box = AssociateValueBox()
        objc_setAssociatedObject(base, &AssociateKey.disposeBag, box, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return box
    }

    /// A set of cancellables associated with the object.
    /// Any subscriptions added to this set will be cancelled when this object is deallocated.
    var disposeBag: Set<AnyCancellable> {
        get { box.get() }
        set { box.set(newValue) }
    }

    /// Stores a cancellable in the object's dispose bag.
    func store(_ cancellable: AnyCancellable) {
        box.insert(cancellable)
    }

    /// Cancels all stored subscriptions and removes them from the bag.
    func cancelAllCancellables() {
        box.cancelAndRemoveAll()
    }

    /// Internal alias for backward compatibility.
    fileprivate func storeCancellable(_ cancellabel: AnyCancellable) {
        store(cancellabel)
    }
}

// MARK: - AnyCancellable + Extension

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension AnyCancellable {
    /// Stores this cancellable instance in the specified NSObject's dispose bag.
    ///
    /// - Parameter object: The NSObject instance in whose dispose bag to store this cancellable.
    func store(in object: NSObject) {
        object.zd.store(self)
    }
}

// MARK: - Publisher + Extension

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension PassthroughSubject: ZDSAny {}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ZDSWrapper where T: Publisher {
    /// Subscribes to the publisher and stores the subscription in the specified object's dispose bag.
    ///
    /// - Parameters:
    ///   - object: The object that determines the lifetime of the subscription.
    ///   - receiveCompletion: The closure to execute on completion.
    ///   - receiveValue: The closure to execute on receipt of a value.
    /// - Returns: An `AnyCancellable` instance.
    @discardableResult
    func store(
        in object: NSObject,
        receiveCompletion: @escaping (Subscribers.Completion<T.Failure>) -> Void = { _ in },
        receiveValue: @escaping (T.Output) -> Void
    ) -> AnyCancellable {
        let cancellable = base.sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
        cancellable.store(in: object)
        return cancellable
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ZDSWrapper where T: Publisher, T.Failure == Never {
    /// Subscribes to the publisher and stores the subscription in the specified object's dispose bag.
    ///
    /// - Parameters:
    ///   - object: The object that determines the lifetime of the subscription.
    ///   - receiveValue: The closure to execute on receipt of a value.
    /// - Returns: An `AnyCancellable` instance.
    @discardableResult
    func store(
        in object: NSObject,
        receiveValue: @escaping (T.Output) -> Void
    ) -> AnyCancellable {
        let cancellable = base.sink(receiveValue: receiveValue)
        cancellable.store(in: object)
        return cancellable
    }
}

// MARK: - Publisher + Convenience

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    /// Subscribes to the publisher and stores the duration of the subscription in the specified object's dispose bag.
    ///
    /// - Parameters:
    ///   - object: The NSObject that determines the lifetime of the subscription.
    ///   - receiveCompletion: The closure to execute on completion.
    ///   - receiveValue: The closure to execute on receipt of a value.
    /// - Returns: An `AnyCancellable` instance.
    @discardableResult
    func sink(
        in object: NSObject,
        receiveCompletion: @escaping ((Subscribers.Completion<Failure>) -> Void) = { _ in },
        receiveValue: @escaping ((Output) -> Void)
    ) -> AnyCancellable {
        let cancellable = sink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
        cancellable.store(in: object)
        return cancellable
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Failure == Never {
    /// Subscribes to the publisher and stores the duration of the subscription in the specified object's dispose bag.
    ///
    /// - Parameters:
    ///   - object: The NSObject that determines the lifetime of the subscription.
    ///   - receiveValue: The closure to execute on receipt of a value.
    /// - Returns: An `AnyCancellable` instance.
    @discardableResult
    func sink(
        in object: NSObject,
        receiveValue: @escaping ((Output) -> Void)
    ) -> AnyCancellable {
        let cancellable = sink(receiveValue: receiveValue)
        cancellable.store(in: object)
        return cancellable
    }
}
