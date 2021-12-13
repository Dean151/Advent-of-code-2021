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

extension Vector2D: Comparable {
    static func < (lhs: Vector2D, rhs: Vector2D) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        }
        return lhs.y < rhs.y
    }
}

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

// MARK: - Print helpers

extension Collection where Iterator.Element == Vector2D {

    func extremumX() -> (minX: Int, maxX: Int)? {
        let values = self.map({ $0.x })
        guard let min = values.min(), let max = values.max() else {
            return nil
        }
        return (min, max)
    }
    func extremumY() -> (minY: Int, maxY: Int)? {
        let values = self.map({ $0.y })
        guard let min = values.min(), let max = values.max() else {
            return nil
        }
        return (min, max)
    }
    
    func print(present: String = "X", absent: String = ".") {
        // Get min and max to iterate on
        guard let (minX, maxX) = extremumX(), let (minY, maxY) = extremumY() else {
            return
        }
        let vectors = Set(self)
        for y in minY...maxY {
            for x in minX...maxX {
                if vectors.contains(.init(x: x, y: y)) {
                    Swift.print(present, terminator: "")
                } else {
                    Swift.print(absent, terminator: "")
                }
            }
            Swift.print("") // \n
        }
    }
}
