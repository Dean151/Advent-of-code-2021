//
//  Bits.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 17/12/2021.
//  Copyright © 2021 Thomas Durand. All rights reserved.
//

import Foundation

enum Bit {
    case zero, one

    var inverted: Bit {
        self == .zero ? .one : .zero
    }

    static func from(_ char: Character) throws -> Bit {
        switch char {
        case "0":
            return .zero
        case "1":
            return .one
        default:
            throw Errors.unparsable
        }
    }
}

extension Collection where Element == Bit {
    var inverted: [Element] {
        map { $0.inverted }
    }

    var decimal: UInt {
        var result: UInt = 0
        for (index, bit) in reversed().enumerated() where bit == .one {
            result += UInt(2 ^^ index)
        }
        return result
    }

    static func from(binary: String) throws -> [Element] {
        var bits = [Bit]()
        for char in binary {
            bits.append(try .from(char))
        }
        return bits
    }
}
