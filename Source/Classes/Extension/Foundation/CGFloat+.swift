//
//  CGFloat+.swift
//  Pods
//
//  Created by Zero_D_Saber on 2025/3/10.
//

public extension ZDSWrapper where T: BinaryFloatingPoint {
    /// Truncates/rounds to a fixed number of fractional digits.
    /// For example, `(2.0 / 3.0).zd.toFixed(1)` returns `0.6` with `.down`.
    ///
    /// - Parameters:
    ///   - digits: Number of fractional digits to keep.
    ///   - rule: Rounding rule.
    /// - Returns: Rounded value.
    ///
    /// Example:
    /// ```swift
    /// let value = (2.0 / 3.0).zd.toFixed(2, .towardZero)
    /// print(value) // 0.66
    /// ```
    func toFixed(_ digits: Int, _ rule: FloatingPointRoundingRule = .down) -> T {
        let dignitsNum = T(pow(10, Double(digits)))
        let finalResult = (base * dignitsNum).rounded(rule) / dignitsNum
        return finalResult
    }
}
