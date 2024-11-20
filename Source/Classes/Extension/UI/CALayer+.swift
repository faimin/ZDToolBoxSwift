//
//  CALayer+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2024/11/20.
//

public extension ZDSWraper where T: CALayer {
    func snapshot(_ size: CGSize = .zero) -> UIImage {
        var newSize = size
        if newSize.width.isZero || newSize.height.isZero {
            newSize = self.base.frame.size
        }
        let render = UIGraphicsImageRenderer(size: newSize)
        let img = render.image { context in
            self.base.render(in: context.cgContext)
        }
        return img
    }
}
