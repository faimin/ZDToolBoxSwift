//
//  UIColor+.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/3/16.
//

import UIKit

// MARK: - UIColor

/// Creates a color from 0...255 RGBA components.
///
/// - Parameters:
///   - red: Red component in 0...255.
///   - green: Green component in 0...255.
///   - blue: Blue component in 0...255.
///   - alpha: Alpha component in 0...1.
/// - Returns: Converted color.
///
/// Example:
/// ```swift
/// let color = RGBA(52, 152, 219, 1.0)
/// ```
public func RGBA(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
}

/// Converts a hex integer to `UIColor` (`0xAARRGGBB` or `0xRRGGBB`).
///
/// - Parameter value: Hex color value.
/// - Returns: Converted color.
///
/// Example:
/// ```swift
/// let color = HEX(0xFF00AA)
/// ```
public func HEX(_ value: Int) -> UIColor {
    var r = 0, g = 0, b = 0
    var a = 0xFF
    var rgb = value

    // 8-digit hex with alpha (`0xAARRGGBB`).
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

/// Converts a hex string to `UIColor`, supporting `0xARGB` and `0xRGB`.
///
/// - Parameter value: Hex string such as `"#FF00AA"` or `"0xF0A"`.
/// - Returns: Converted color, or `.clear` if parsing fails.
///
/// Example:
/// ```swift
/// let color = HEX("#3498DB")
/// ```
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

/// Converts short hex values (`0xARGB` / `0xRGB`) to `UIColor`.
///
/// - Parameter value: Short hex value.
/// - Returns: Converted color.
///
/// Example:
/// ```swift
/// let color = HEXShort(0xF0A) // rgb short
/// ```
public func HEXShort(_ value: Int) -> UIColor {
    var r = 0, g = 0, b = 0
    var a = 0xFF
    var rgb = value

    // Hex value with alpha component (`ARGB`).
    if value & 0xF000 > 0 {
        a = (value & 0xF000) >> 12
        rgb = value & 0x0FFF
    } else {
        a = 0xF
        rgb = value
    }

    r = (rgb & 0x0F00) >> 8
    // Expand single nibble into full byte, e.g. `r` -> `rr`.
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
    /// Indicates whether the color uses a pattern color space.
    ///
    /// Example:
    /// ```swift
    /// let isPattern = UIColor.red.zd.isPatternColor
    /// ```
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
