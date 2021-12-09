
import Foundation

struct Day09: Day {
    static func test() throws {
        let testInput = """
2199943210
3987894921
9856789892
8767896789
9899965678
"""
        let heightMap = try HeightMap.from(input: testInput)
        let mins = heightMap.localMins
        precondition(mins.count == 4)
        precondition(mins.values.reduce(0, +) + mins.count == 15)
        let biggest = heightMap.bassins.sorted(by: { $0.count > $1.count })[0..<3]
        precondition(biggest.count == 3)
        precondition(biggest.map({ $0.count }).reduce(1, *) == 1134)
    }

    static func run(input: String) throws {
        let heightMap = try HeightMap.from(input: input)
        let mins = heightMap.localMins
        print("Sum of risk levels for Day 9-1 is \(mins.values.reduce(0, +) + mins.count)")
        let biggest = heightMap.bassins.sorted(by: { $0.count > $1.count })[0..<3]
        print("Multiplication of bassins sizes for Day 9-2 is \(biggest.map({ $0.count }).reduce(1, *))")
    }

    struct HeightMap {
        let heights: [Vector2D: Int]

        var localMins: [Vector2D: Int] {
            func minNeightboard(of point: Vector2D) -> Int {
                point.adjacents().compactMap({ heights[$0] }).min().unsafelyUnwrapped
            }
            var mins: [Vector2D: Int] = [:]
            for (point,height) in heights {
                if minNeightboard(of: point) > height {
                    mins[point] = height
                }
            }
            return mins
        }

        var bassins: [Set<Vector2D>] {
            func makeBassin(_ bassin: inout Set<Vector2D>, from point: Vector2D) {
                for point in point.adjacents().subtracting(bassin) {
                    guard let height = heights[point], height != 9 else {
                        continue
                    }
                    bassin.insert(point)
                    makeBassin(&bassin, from: point)
                }
            }

            var bassins: [Set<Vector2D>] = []
            for (position,_) in localMins {
                var bassin: Set<Vector2D> = [position]
                makeBassin(&bassin, from: position)
                bassins.append(bassin)
            }
            return bassins
        }

        static func from(input: String) throws -> HeightMap {
            var heights: [Vector2D: Int] = [:]
            for (y,line) in input.components(separatedBy: .newlines).enumerated() where !line.isEmpty {
                for (x,char) in line.enumerated() {
                    guard let height = Int("\(char)") else {
                        throw Errors.unparsable
                    }
                    heights[.init(x: x, y: y)] = height
                }
            }
            return .init(heights: heights)
        }
    }
}
