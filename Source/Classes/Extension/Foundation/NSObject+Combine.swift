//
//  NSObject+Combine.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/1/21.
//

import Combine
import ObjectiveC.runtime
import Foundation

// MARK: - AssociateKey

nonisolated private enum AssociateKey {
    nonisolated(unsafe) static var disposeBag: Void?
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ZDSWrapper where T: NSObject {
    private class AssociateValueBox: NSObject {
        // MARK: Properties

        fileprivate var disposeBag: Set<AnyCancellable>

        // MARK: Lifecycle

        init(disposeBag: Set<AnyCancellable> = []) {
            self.disposeBag = disposeBag
        }
    }

    var disposeBag: Set<AnyCancellable> {
        get {
            if let cancellableBox = objc_getAssociatedObject(
                self,
                &AssociateKey.disposeBag
            ) as? AssociateValueBox {
                return cancellableBox.disposeBag
            }
            let cancellableBox = AssociateValueBox()
            objc_setAssociatedObject(self, &AssociateKey.disposeBag, cancellableBox, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return cancellableBox.disposeBag
        }
        set {
            guard let cancellableBox = objc_getAssociatedObject(
                self,
                &AssociateKey.disposeBag
            ) as? AssociateValueBox else {
                #if DEBUG
                fatalError(
                    "It is not as expected. You should execute get first and then set. The box should have been created when getting."
                )
                #else
                return
                #endif
            }
            cancellableBox.disposeBag = newValue
        }
    }

    fileprivate mutating func storeCancellable(_ cancellabel: AnyCancellable) {
        disposeBag.insert(cancellabel)
    }

    mutating func cancelAllCancellables() {
        disposeBag.removeAll()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension ZDSWrapper where T: Publisher {
    @discardableResult
    func store(
        in object: NSObject,
        receiveValue: @escaping (T.Output) -> Void
    ) -> AnyCancellable {
        let cancellable = base.sink(
            receiveCompletion: { _ in },
            receiveValue: receiveValue
        )
        var _object = object
        _object.zd.storeCancellable(cancellable)
        return cancellable
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension ZDSWrapper where T: Publisher, T.Failure == Never {
    @discardableResult
    func store(
        in object: NSObject,
        receiveCompletion: @escaping (Subscribers.Completion<T.Failure>) -> Void,
        receiveValue: @escaping (T.Output) -> Void
    ) -> AnyCancellable {
        let cancellable = base.sink(
            receiveCompletion: receiveCompletion,
            receiveValue: receiveValue
        )
        var _object = object
        _object.zd.storeCancellable(cancellable)
        return cancellable
    }
}
