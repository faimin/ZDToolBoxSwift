//
//  UIColor+ZDExtention.swift
//  ZDSwiftToolKit
//
//  Created by Zero.D.Saber on 2021/3/16.
//

import Foundation

/// 使用16进制数字转换为颜色
public func HEX(_ value: Int) -> UIColor {
    
    var r: Int = 0, g: Int = 0, b: Int = 0;
    var a: Int = 0xFF
    var rgb = value
    
    if (value & 0xFFFF0000) == 0 {
        a = 0xF
        
        if value & 0xF000 > 0 {
            a = value & 0xF
            rgb = value >> 4
        }
        
        r = (rgb & 0xF00) >> 8
        r = (r << 4) | r
        
        g = (rgb & 0xF0) >> 4
        g = (g << 4) | g
        
        b = rgb & 0xF
        b = (b << 4) | b
        
        a = (a << 4) | a
    }
    else {
        if value & 0xFF000000 > 0 {
            a = value & 0xFF
            rgb = value >> 8
        }
        
        r = (rgb & 0xFF0000) >> 16
        g = (rgb & 0xFF00) >> 8
        b = rgb & 0xFF
    }
    
    //NSLog("r:%X g:%X b:%X a:%X", r, g, b, a)
    
    return UIColor(red: CGFloat(r) / 255.0,
                   green: CGFloat(g) / 255.0,
                   blue: CGFloat(b) / 255.0,
                   alpha: CGFloat(a) / 255.0)
}

/// 使用16进制字符串转换为颜色
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
    
    guard let hexInt = Int(hexString, radix: 16) else {
        return UIColor.clear
    }
    
    return HEX(hexInt)
}
