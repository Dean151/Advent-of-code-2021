//
//  Maths.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 03/12/2021.
//  Copyright © 2021 Thomas Durand. All rights reserved.
//

import Foundation

// MARK: - Power

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

// MARK: - Sum of integers

func sumOfIntegers(upTo number: Int) -> Int {
    if number == 0 {
        return 0
    }
    return number * (number + 1) / 2
}
