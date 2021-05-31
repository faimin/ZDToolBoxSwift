//
//  NotificationCenter+ZDExtention.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/2/5.
//

import Foundation

public final class ZDSNotificationToken {
    private weak var notificationCenter: NotificationCenter?
    private var token: NSObjectProtocol?
    
    deinit {
        dispose()
    }
    
    public init(notificationCenter: NotificationCenter = .default, token: NSObjectProtocol) {
        self.notificationCenter = notificationCenter
        self.token = token
    }
    
    public func dispose() {
        guard let token = token else { return }
        
        notificationCenter?.removeObserver(token)
        self.token = nil
    }
}

public extension ZDSWraper where T == NotificationCenter {
    
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
}
