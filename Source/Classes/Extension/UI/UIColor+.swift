//
//  UIColor+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/3/16.
//

import UIKit

// MARK: - UIColor

public func RGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
}

/// 16进制数字转换为颜色(0xAARRGGBB, 0xRRGGBB)
public func HEX(_ value: Int) -> UIColor {
    var r = 0, g = 0, b = 0
    var a = 0xFF
    var rgb = value

    // 带alpha值的8位hex (0xAARRGGBB)
    if value & 0xFF00_0000 > 0 {
        a = (value & 0xFF00_0000) >> 24
        rgb = value & 0x00FF_FFFF
    }

    r = (rgb & 0x00FF_0000) >> 16
    g = (rgb & 0x0000_FF00) >> 8
    b = rgb & 0x0000_00FF

    return UIColor(
        red: CGFloat(r) / 255.0,
        green: CGFloat(g) / 255.0,
        blue: CGFloat(b) / 255.0,
        alpha: CGFloat(a) / 255.0
    )
}

/// 16进制字符串转换`UIColor`, 兼容 “0xARGB”、“0xRGB”
public func HEX(_ value: String) -> UIColor {
    let hexString: String
    let lowercasedStr = value.lowercased()
    if lowercasedStr.hasPrefix("0x") {
        hexString = lowercasedStr.replaceText("0x", newStr: "")
    } else if value.hasPrefix("#") {
        hexString = value.replaceText("#", newStr: "")
    } else {
        hexString = value
    }

    guard let hexInt = Int(hexString, radix: 16) else {
        return UIColor.clear
    }

    if hexString.count <= 4 {
        return HEXShort(hexInt)
    }
    return HEX(hexInt)
}

/// 3-4位hex，如0xARGB、0xRGB
public func HEXShort(_ value: Int) -> UIColor {
    var r = 0, g = 0, b = 0
    var a = 0xFF
    var rgb = value

    // 带alpha值的hex(ARGB)
    if value & 0xF000 > 0 {
        a = (value & 0xF000) >> 12
        rgb = value & 0x0FFF
    } else {
        a = 0xF
        rgb = value
    }

    r = (rgb & 0x0F00) >> 8
    // 把R、G、B 凑成2位
    // 左移一位然后把r放后面，最终成为rr
    r |= (r << 4)

    g = (rgb & 0x00F0) >> 4
    g |= (g << 4)

    b = rgb & 0x000F
    b |= (b << 4)

    a |= (a << 4)

    return UIColor(
        red: CGFloat(r) / 255.0,
        green: CGFloat(g) / 255.0,
        blue: CGFloat(b) / 255.0,
        alpha: CGFloat(a) / 255.0
    )
}

public extension ZDSWrapper where T: UIColor {
    var isPatternColor: Bool {
        return base.cgColor.colorSpace?.model == .pattern
    }
}

private extension String {
    func replaceText(_ oldStr: String, newStr: String) -> String {
        if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
            return self.replacing(oldStr, with: newStr)
        } else {
            return replacingOccurrences(of: oldStr, with: newStr)
        }
    }
}
