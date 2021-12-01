//
//  Day+Helper.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 01/12/2021.
//  Copyright © 2021 Thomas Durand. All rights reserved.
//

import Foundation

extension Day {
    static func integers(from input: String, separatedBy separator: CharacterSet = .newlines) throws -> [Int] {
        let components = input.components(separatedBy: separator)
        let integers = components.compactMap { Int($0) }
        guard integers.count == components.count else {
            throw Errors.unparsable
        }
        return integers
    }
}
