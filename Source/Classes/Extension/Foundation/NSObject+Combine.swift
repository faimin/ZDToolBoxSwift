//
//  NSObject+Combine.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/1/21.
//

import Combine
import ObjectiveC.runtime

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension NSObject {
    private enum AssociateKey {
        nonisolated(unsafe) static var disposeBag: Void?
    }

    var zd_disposeBag: Set<AnyCancellable> {
        get {
            if let collector = objc_getAssociatedObject(
                self,
                &AssociateKey.disposeBag
            ) as? Set<AnyCancellable> {
                return collector
            }
            let collector = Set<AnyCancellable>()
            self.zd_disposeBag = collector
            return collector
        }
        set {
            let b = newValue
            objc_setAssociatedObject(self, &AssociateKey.disposeBag, b, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func zd_storeCancellable(_ cancellabel: AnyCancellable) {
        zd_disposeBag.insert(cancellabel)
    }

    func zd_cancelAllCancellables() {
        zd_disposeBag.removeAll()
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher where Self.Failure == Never {
    @discardableResult
    func zd_store(in object: NSObject, receiveValue: @escaping (Output) -> Void) -> AnyCancellable {
        let cancellable = sink(
            receiveCompletion: { _ in },
            receiveValue: receiveValue
        )
        object.zd_storeCancellable(cancellable)
        return cancellable
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension Publisher {
    @discardableResult
    func zd_store(
        in object: NSObject,
        receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping (Output) -> Void
    ) -> AnyCancellable {
        let cancellable = sink(
            receiveCompletion: receiveCompletion,
            receiveValue: receiveValue
        )
        object.zd_storeCancellable(cancellable)
        return cancellable
    }
}
