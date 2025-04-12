//
//  UIApplication.swift
//  Pods
//
//  Created by Zero.D.Saber on 2025/3/29.
//

#if canImport(UIKit)
    import UIKit

    @MainActor
    public extension ZDSWraper where T: UIApplication {
        /// https://github.com/reers/ReerKit/blob/main/Sources/ReerKit/UIKit/UIApplication+REExtensions.swift
        static var keyWindow: UIWindow? {
            let application = UIApplication.shared
            if let delegeWindow = application.delegate?.window, let delegeWindow = delegeWindow {
                return delegeWindow
            }

            guard #available(iOS 13.0, tvOS 13.0, *) else {
                let keyWindow = application.keyWindow
                return keyWindow
            }

            let mainWindow = application
                .connectedScenes
                .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
                .compactMap { $0 as? UIWindowScene }
                .compactMap { $0.windows.first(where: \UIWindow.isKeyWindow) }
                .first
            return mainWindow
        }
    }

    @available(iOS 13.0, tvOS 13.0, *)
    private extension UIScene.ActivationState {
        var sortPriority: Int {
            switch self {
            case .foregroundActive: return 1
            case .foregroundInactive: return 2
            case .background: return 3
            case .unattached: return 4
            @unknown default: return 5
            }
        }
    }

#endif
