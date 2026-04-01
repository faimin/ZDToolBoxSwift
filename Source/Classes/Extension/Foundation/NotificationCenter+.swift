//
//  NotificationCenter+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/2/5.
//

import Foundation

// MARK: - ZDSNotificationToken

public final class ZDSNotificationToken {
    // MARK: Properties

    private weak var notificationCenter: NotificationCenter?
    private var token: NSObjectProtocol

    // MARK: Lifecycle

    public init(notificationCenter: NotificationCenter = .default, token: NSObjectProtocol) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        dispose()
    }

    // MARK: Functions

    /// Removes the observer manually.
    /// Safe to call multiple times; it is a no-op if `NotificationCenter` has been released.
    ///
    /// Example:
    /// ```swift
    /// let token = NotificationCenter.default.zd.addObserver(
    ///     forName: UIApplication.didBecomeActiveNotification,
    ///     object: nil,
    ///     queue: .main
    /// ) { _ in }
    /// token.dispose()
    /// ```
    public func dispose() {
        notificationCenter?.removeObserver(token)
    }
}

// MARK: Hashable

extension ZDSNotificationToken: Hashable {
    public static func == (lhs: ZDSNotificationToken, rhs: ZDSNotificationToken) -> Bool {
        return ObjectIdentifier(lhs.token) == ObjectIdentifier(rhs.token)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(token))
    }
}

private nonisolated(unsafe) var NotificationTokenKey: Void?

public extension ZDSWrapper where T == NotificationCenter {
    private func tokens(_ observer: Any) -> NSMutableSet {
        guard let value = objc_getAssociatedObject(observer, &NotificationTokenKey) as? NSMutableSet else {
            let set = NSMutableSet()
            objc_setAssociatedObject(observer, &NotificationTokenKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return set
        }
        return value
    }

    /// Adds an observer without retaining the owner.
    /// Keep the returned token alive; otherwise it will be removed when leaving scope.
    ///
    /// Example:
    /// ```swift
    /// final class VM {
    ///     var token: ZDSNotificationToken?
    ///     func start() {
    ///         token = NotificationCenter.default.zd.addObserver(
    ///             forName: UIApplication.didBecomeActiveNotification,
    ///             object: nil,
    ///             queue: .main
    ///         ) { _ in }
    ///     }
    /// }
    /// ```
    func addObserver(
        forName name: Notification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @Sendable @escaping (Notification) -> Void
    ) -> ZDSNotificationToken {
        let token = base.addObserver(forName: name, object: obj, queue: queue, using: block)
        return ZDSNotificationToken(notificationCenter: base, token: token)
    }

    /// Adds an observer token that is automatically removed when `observer` is deallocated.
    ///
    /// Example:
    /// ```swift
    /// NotificationCenter.default.zd.addObserver(
    ///     observer: self,
    ///     forName: UIApplication.didBecomeActiveNotification,
    ///     object: nil,
    ///     queue: .main
    /// ) { [weak self] _ in
    ///     self?.reload()
    /// }
    /// ```
    func addObserver(
        observer: Any,
        forName name: Notification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @Sendable @escaping (Notification) -> Void
    ) {
        let token = base.addObserver(forName: name, object: obj, queue: queue, using: block)
        let notificationToken = ZDSNotificationToken(notificationCenter: base, token: token)
        tokens(observer).add(notificationToken)
    }
}
