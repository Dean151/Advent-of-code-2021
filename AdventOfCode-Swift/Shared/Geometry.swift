//
//  Geometry.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 05/12/2021.
//  Copyright © 2021 Thomas Durand. All rights reserved.
//

import Foundation

struct Vector2D {
    static var zero = Vector2D(x: 0, y: 0)

    let x: Int
    let y: Int
}

// MARK: - Initialisations

extension Vector2D {
    static func from(string: String, separator: String = ",") throws -> Vector2D {
        let components = string.components(separatedBy: separator)
        if components.count != 2 {
            throw Errors.unparsable
        }
        guard let x = Int(components.first!), let y = Int(components.last!) else {
            throw Errors.unparsable
        }
        return .init(x: x, y: y)
    }
}

extension Vector2D {
    func stride(to other: Vector2D, withDiagonals: Bool = false, perform: (Vector2D) -> Void) {
        let minX = min(x, other.x)
        let maxX = max(x, other.x)
        let minY = min(y, other.y)
        let maxY = max(y, other.y)
        if (self.y == other.y) {
            for x in minX...maxX {
                perform(.init(x: x, y: y))
            }
        } else if (self.x == other.x) {
            for y in minY...maxY {
                perform(.init(x: x, y: y))
            }
        } else if withDiagonals {
            let dimensionX = maxX - minX
            let dimensionY = maxY - minY
            if dimensionX == dimensionY {
                for index in 0...dimensionX {
                    if other.y - other.x == y - x {
                        perform(.init(x: minX + index, y: minY + index))
                    } else {
                        perform(.init(x: minX + index, y: maxY - index))
                    }
                }
            } else {
                fatalError("Not supported")
            }
        }
    }
}

// MARK: - Conformance

extension Vector2D: Hashable, Equatable {}
