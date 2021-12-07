
import Foundation

struct Day05: Day {
    static func test() throws {
        let testInput = """
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
"""
        let vents = try ThermalVent.from(input: testInput)
        precondition(solve(for: vents) == 5)
        precondition(solve(for: vents, ignoreDiagonals: false) == 12)
    }

    static func run(input: String) throws {
        let vents = try ThermalVent.from(input: input)
        print("Number of points with at least 2 thermal vents is \(solve(for: vents)) for Day 5-1")
        print("Number of points with at least 2 thermal vents is \(solve(for: vents, ignoreDiagonals: false)) for Day 5-2")
    }

    struct ThermalVent {
        let start: Vector2D
        let end: Vector2D

        var isHorizontal: Bool {
            start.y == end.y
        }
        var isVertical: Bool {
            start.x == end.x
        }
        var isDiagonal: Bool {
            abs(end.x - start.x) == abs(end.y - start.y)
        }

        var orderedX: (Int, Int) {
            if start.x > end.x {
                return (end.x, start.x)
            } else {
                return (start.x, end.x)
            }
        }
        var orderedY: (Int, Int) {
            if start.y > end.y {
                return (end.y, start.y)
            } else {
                return (start.y, end.y)
            }
        }

        init(start: Vector2D, end: Vector2D) {
            self.start = start
            self.end = end
            precondition(isHorizontal || isVertical || isDiagonal)
        }

        func stride(perform: (Vector2D) -> Void) {
            if isHorizontal {
                let (minX, maxX) = orderedX
                for x in minX...maxX {
                    perform(.init(x: x, y: start.y))
                }
            } else if isVertical {
                let (minY, maxY) = orderedY
                for y in minY...maxY {
                    perform(.init(x: start.x, y: y))
                }
            } else {
                let dimension = abs(end.x - start.x)
                let (minX, _) = orderedX
                let (minY, maxY) = orderedY
                for index in 0...dimension {
                    if end.y - end.x == start.y - start.x {
                        perform(.init(x: minX + index, y: minY + index))
                    } else {
                        perform(.init(x: minX + index, y: maxY - index))
                    }
                }
            }
        }

        static func from(line: String) throws -> ThermalVent {
            let components = line.components(separatedBy: " -> ")
            precondition(components.count == 2)
            let (start, end) = (try Vector2D.from(string: components.first!), try Vector2D.from(string: components.last!))
            precondition(start != end)
            return .init(start: start, end: end)
        }

        static func from(input: String) throws -> [ThermalVent] {
            try input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).map({ try .from(line: $0) })
        }
    }

    static func solve(for vents: [ThermalVent], ignoreDiagonals: Bool = true) -> Int {
        var points: Set<Vector2D> = []
        var intersections: Set<Vector2D> = []
        for vent in vents {
            if vent.isDiagonal && ignoreDiagonals {
                continue
            }
            vent.stride { point in
                if points.contains(point) {
                    intersections.insert(point)
                } else {
                    points.insert(point)
                }
            }
        }
        return intersections.count
    }
}
