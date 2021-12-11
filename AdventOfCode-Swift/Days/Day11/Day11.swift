
import Foundation

struct Day11: Day {
    static func test() throws {
        let smallInput = """
11111
19991
19191
19991
11111
"""
        let shouldBeNine = try Cave.from(input: smallInput).after(2).flashes
        precondition(shouldBeNine == 9)

        let testInput = """
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526
"""
        var cave = try Cave.from(input: testInput).after(10)
        let shouldBe204 = cave.flashes
        precondition(shouldBe204 == 204)

        cave = cave.after(90) // 90 + 10 = 100
        let shouldBe1656 = cave.flashes
        precondition(shouldBe1656 == 1656)

        let stepsForSync = cave.findSync() + 100
        precondition(stepsForSync == 195)
    }

    static func run(input: String) throws {
        let cave = try Cave.from(input: input)
        let after100 = cave.after(100)
        print("Number of flashes after 100 steps for Day 11-1 is \(after100.flashes)")
        let stepsForSync = after100.findSync() + 100
        print("Number of steps required for syncing for Day 11-2 is \(stepsForSync)")
    }

    struct Cave {
        var octopuses: [Vector2D: Int]
        var flashes: Int = 0

        @discardableResult
        static func execute(with octopuses: inout [Vector2D: Int]) -> Int {
            var flashes = 0
            var toIncrement: [Vector2D] = []
            func increment(at point: Vector2D) {
                guard let level = octopuses[point] else {
                    return
                }
                octopuses[point] = level + 1
                if level == 9 {
                    toIncrement.append(contentsOf: point.adjacents(withDiagonals: true))
                    flashes += 1
                }
            }
            for point in octopuses.keys {
                increment(at: point)
            }
            while let point = toIncrement.popLast() {
                increment(at: point)
            }
            // Reset all octopuses above or equals 9
            for point in octopuses.keys where octopuses[point]! > 9 {
                octopuses[point] = 0
            }
            return flashes
        }

        func after(_ steps: Int) -> Cave {
            var octopuses = octopuses
            var flashes = flashes
            for _ in 0..<steps {
                flashes += Self.execute(with: &octopuses)
            }
            return .init(octopuses: octopuses, flashes: flashes)
        }

        func findSync() -> Int {
            var octopuses = octopuses
            var steps = 0
            while !octopuses.filter({ $0.value != 0 }).isEmpty {
                steps += 1
                Self.execute(with: &octopuses)
            }
            return steps
        }

        static func from(input: String) throws -> Cave {
            var octopuses: [Vector2D: Int] = [:]
            for (y, line) in input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).enumerated() {
                for (x, char) in line.enumerated() {
                    octopuses[.init(x: x, y: y)] = Int("\(char)")!
                }
            }
            return .init(octopuses: octopuses)
        }
    }
}

