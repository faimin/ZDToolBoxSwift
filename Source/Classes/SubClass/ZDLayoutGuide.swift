//
//  ZDLayoutGuide.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/12/6.
//

#if DEBUG
public final class ZDLayoutGuide: UILayoutGuide {
    // MARK: Properties

    public var onFrameChange: ((CGRect) -> Void)?

    // MARK: Overridden Functions

    public override func _updateLayoutFrame(inOwningView arg1: Any!, fromEngine arg2: Any!) {
        super._updateLayoutFrame(inOwningView: arg1, fromEngine: arg2)
        onFrameChange?(layoutFrame)
    }
}
#endif
