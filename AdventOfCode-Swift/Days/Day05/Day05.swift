
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
        let thermalVents = try ThermalVents.from(input: testInput)
        precondition(thermalVents.numberOfPoints(withAtLeast: 2) == 5)
        let withDiagonals = try ThermalVents.from(input: testInput, withDiagonals: true)
        precondition(withDiagonals.numberOfPoints(withAtLeast: 2) == 12)
    }

    static func run(input: String) throws {
        let thermalVents = try ThermalVents.from(input: input)
        print("Number of points with at least 2 thermal vents is \(thermalVents.numberOfPoints(withAtLeast: 2)) for Day 5-1")
        let withDiagonals = try ThermalVents.from(input: input, withDiagonals: true)
        print("Number of points with at least 2 thermal vents is \(withDiagonals.numberOfPoints(withAtLeast: 2)) for Day 5-2")
    }

    struct ThermalVents {
        let vents: [Vector2D: Int]

        func numberOfPoints(withAtLeast: Int) -> Int {
            vents.count(where: { $0.value >= withAtLeast })
        }

        static func from(input: String, withDiagonals: Bool = false) throws -> ThermalVents {
            var vents: [Vector2D: Int] = [:]
            for line in input.components(separatedBy: .newlines) where !line.isEmpty {
                let components = line.components(separatedBy: " -> ")
                assert(components.count == 2)
                let (start, end) = (try Vector2D.from(string: components.first!), try Vector2D.from(string: components.last!))
                start.stride(to: end, withDiagonals: withDiagonals) { vector in
                    if let count = vents[vector] {
                        vents[vector] = count + 1
                    } else {
                        vents[vector] = 1
                    }
                }
            }
            return .init(vents: vents)
        }
    }
}
