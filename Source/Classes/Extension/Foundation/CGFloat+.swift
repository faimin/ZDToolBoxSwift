//
//  CGFloat+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/3/10.
//

public extension ZDSWraper where T: BinaryFloatingPoint {
    /// 小数截取
    /// 比如 2.0 / 3.0截取1位,结果为0.6; 如果要支持四舍五入请修改rule
    func toFixed(_ digits: Int, _ rule: FloatingPointRoundingRule = .down) -> T {
        let dignitsNum = T(pow(10, Double(digits)))
        let finalResult = (base * dignitsNum).rounded(rule) / dignitsNum
        return finalResult
    }
}
