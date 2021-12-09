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

// MARK: - Conformance

extension Vector2D: Hashable, Equatable {}

// MARK: - Adjacents {

extension Vector2D {
    func adjacents(withDiagonals: Bool = false) -> Set<Vector2D> {
        let adjacents: Set<Vector2D> = [
            .init(x: x - 1, y: y),
            .init(x: x, y: y - 1),
            .init(x: x + 1, y: y),
            .init(x: x, y: y + 1)
        ]
        if withDiagonals {
            return adjacents.union([
                .init(x: x - 1, y: y - 1),
                .init(x: x - 1, y: y + 1),
                .init(x: x + 1, y: y - 1),
                .init(x: x + 1, y: y + 1)
            ])
        }
        return adjacents
    }
}

