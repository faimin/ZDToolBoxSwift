//
//  NotificationCenter+ZDExtension.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/2/5.
//

import Foundation

public final class ZDSNotificationToken {
    private unowned var notificationCenter: NotificationCenter?
    private var token: NSObjectProtocol
    
    deinit {
        dispose()
    }
    
    public init(notificationCenter: NotificationCenter = .default, token: NSObjectProtocol) {
        self.notificationCenter = notificationCenter
        self.token = token
    }
    
    public func dispose() {
        notificationCenter?.removeObserver(token)
    }
}

extension ZDSNotificationToken: Hashable {
    public static func == (lhs: ZDSNotificationToken, rhs: ZDSNotificationToken) -> Bool {
        return ObjectIdentifier(lhs.token) == ObjectIdentifier(rhs.token)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(token))
    }
}

private var NotificationTokenKey: Void?

public extension ZDSWraper where T == NotificationCenter {
    
    private func tokens(_ observer: Any) -> NSMutableSet {
        var set = objc_getAssociatedObject(observer, &NotificationTokenKey) as? NSMutableSet
        guard let value = set else {
            set = NSMutableSet()
            objc_setAssociatedObject(observer, &NotificationTokenKey, set, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return set!
        }
        return value
    }
    
    /// 打破引用环的通知监听；
    /// 需要外界持有`token`，否则出当前作用域后通知就会被移除掉，导致收不到通知
    func addObserver(
        forName name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) -> ZDSNotificationToken {
        let token = self.base.addObserver(forName: name, object: obj, queue: queue, using: block)
        return ZDSNotificationToken(notificationCenter: self.base, token: token)
    }
    
    /// 自动移除token的通知(Observer析构时)
    func addObserver(
        observer: Any,
        forName name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) {
        let token = self.base.addObserver(forName: name, object: obj, queue: queue, using: block)
        let notificationToken = ZDSNotificationToken(notificationCenter: self.base, token: token)
        tokens(observer).add(notificationToken)
    }
}
