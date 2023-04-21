//
//  Correlate.swift
//  Palpi
//
//  Created by  on 4/20/23.
//
import Darwin
import Accelerate
func crossCorrelation(x: [Double], y: [Double]) -> (correlation: [Double], pValue: Double) {
    let n = vDSP_Length(x.count + y.count - 1)
    let resultLength = Int(n)
    var result = [Double](repeating: 0.0, count: resultLength)
    vDSP_convD(x, 1, y, 1, &result, 1, n, n)
    
    // Calculate cross-correlation coefficient
    let meanX = x.reduce(0, +) / Double(x.count)
    let meanY = y.reduce(0, +) / Double(y.count)
    let numerator = zip(x, y).map { ($0 - meanX) * ($1 - meanY) }.reduce(0, +)
    let denominatorX = x.map { ($0 - meanX) * ($0 - meanX) }.reduce(0, +)
    let denominatorY = y.map { ($0 - meanY) * ($0 - meanY) }.reduce(0, +)
    let correlation = numerator / sqrt(denominatorX * denominatorY)
    
    // Calculate p-value
    let degreesOfFreedom = x.count + y.count - 2
    let tStatistic = correlation * sqrt(Double(degreesOfFreedom) / (1 - correlation * correlation))
    let pValue = 2 * (1 - tCDF(tStatistic, degreesOfFreedom))
    
    return (correlation: result, pValue: pValue)
}

//// T-distribution cumulative distribution function
func tCDF(_ t: Double, _ degreesOfFreedom: Int) -> Double {
    
    
    let numeratorGamma = lgammal((Double(degreesOfFreedom + 1) / 2.0))
    let denominatorGamma = lgammal(Double(degreesOfFreedom) / 2.0)
    let denominatorPower = pow(Double(1 + (t * t) / Double(degreesOfFreedom)), Double(degreesOfFreedom + 1) / 2.0)
    let num = (numeratorGamma - denominatorGamma)
    let den = log(sqrt(Double.pi * Double(degreesOfFreedom)))
    return 0.5 * (1 + num/den - log(denominatorPower))
}

