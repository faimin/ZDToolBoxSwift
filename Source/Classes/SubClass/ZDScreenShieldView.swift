//
//  ZDScreenShieldView.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/4/11.
//
//  Another:
//  https://github.com/Kyle-Ye/ScreenShieldKit
//  https://github.com/JayantBadlani/ScreenShield
//
//  Screen-capture protection

@available(iOS 13, *)
public final class ZDScreenShieldView: UIView {
    // MARK: Properties

    private lazy var shieldView = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()

    // MARK: Lifecycle

    override public init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Functions

    private func _setupUI() {
        addSubview(shieldView)

        shieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shieldView.widthAnchor.constraint(equalTo: widthAnchor),
            shieldView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
