//
//  UIColor+ZDExtension.swift
//  ZDToolBoxSwift
//
//  Created by Zero.D.Saber on 2021/3/16.
//

import Foundation

// MARK: - 颜色
public func RGBA(_ red: Int, _ green: Int, _ blue: Int, _ alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
}

/// 16进制数字转换为颜色(0xAARRGGBB, 0xRRGGBB)
public func HEX(_ value: Int) -> UIColor {
    
    var r: Int = 0, g: Int = 0, b: Int = 0;
    var a: Int = 0xFF
    var rgb = value
    
    //带alpha值的8位hex (0xAARRGGBB)
    if value & 0xFF000000 > 0 {
        a = (value & 0xFF000000) >> 24
        rgb = value & 0x00FFFFFF
    }
    
    r = (rgb & 0x00FF0000) >> 16
    g = (rgb & 0x0000FF00) >> 8
    b = rgb & 0x000000FF
    
    return UIColor(red: CGFloat(r) / 255.0,
                   green: CGFloat(g) / 255.0,
                   blue: CGFloat(b) / 255.0,
                   alpha: CGFloat(a) / 255.0)
}

/// 16进制字符串转换`UIColor`, 兼容 “0xARGB”、“0xRGB”
public func HEX(_ value: String) -> UIColor {
    
    var hexString = ""
    if value.lowercased().hasPrefix("0x") {
        hexString = value.lowercased().replacingOccurrences(of: "0x", with: "")
    }
    else if value.hasPrefix("#") {
        hexString = value.replacingOccurrences(of: "#", with: "")
    }
    else {
        hexString = value
    }
    
    if hexString.count <= 4 {
        guard let hexInt = Int(hexString, radix: 16) else {
            return UIColor.clear
        }
        
        return HEXShort(hexInt)
    }
    else {
        guard let hexInt = Int(hexString, radix: 16) else {
            return UIColor.clear
        }
        
        return HEX(hexInt)
    }
}

/// 3-4位hex，如0xARGB、0xRGB
public func HEXShort(_ value: Int) -> UIColor {
    
    var r: Int = 0, g: Int = 0, b: Int = 0;
    var a: Int = 0xFF
    var rgb = value
    
    // 带alpha值的hex(ARGB)
    if value & 0xF000 > 0 {
        a = (value & 0xF000) >> 12
        rgb = value & 0x0FFF
    }
    else {
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
    
    return UIColor(red: CGFloat(r) / 255.0,
                   green: CGFloat(g) / 255.0,
                   blue: CGFloat(b) / 255.0,
                   alpha: CGFloat(a) / 255.0)
}
