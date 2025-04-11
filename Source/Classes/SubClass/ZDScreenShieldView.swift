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
//  防截屏

@available(iOS 13, *)
public final class ZDScreenShieldView: UIView {
    private lazy var shieldView = {
        let view = UITextField()
        view.isSecureTextEntry = true
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _setupUI() {
        addSubview(shieldView)
        
        shieldView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shieldView.widthAnchor.constraint(equalTo: self.widthAnchor),
            shieldView.heightAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}
