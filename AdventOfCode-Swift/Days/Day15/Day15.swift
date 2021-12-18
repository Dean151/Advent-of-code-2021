
import Foundation

struct Day15: Day {
    static func test() throws {
        let testInput = """
1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581
"""
        let cave = try Cave.parse(input: testInput)
        let lowestTotalRisk = try cave.lowestTotalRisk()
        precondition(lowestTotalRisk == 40)
        let fullMapLowestTotalRisk = try cave.lowestTotalRisk(fullMap: true)
        precondition(fullMapLowestTotalRisk == 315)
    }

    static func run(input: String) throws {
        let cave = try Cave.parse(input: input)
        let lowestTotalRisk = try cave.lowestTotalRisk()
        print("Lowest total risk for Day 15-1 is \(lowestTotalRisk)")
        let fullMapLowestTotalRisk = try cave.lowestTotalRisk(fullMap: true)
        print("Full map lowest total risk for Day 15-2 is \(fullMapLowestTotalRisk)")
    }

    struct Cave {
        let risks: [Vector2D: Int]
        let start = Vector2D.zero
        let end: Vector2D

        func lowestTotalRisk(fullMap: Bool = false) throws -> Int {
            let end = fullMap ? Vector2D(x: ((end.x + 1) * 5) - 1, y: ((end.y + 1) * 5) - 1) : end
            var visited: [Vector2D: Int] = .init(minimumCapacity: (end.x + 1) * (end.y + 1))
            var toVisit: [Vector2D: Int] = .init(minimumCapacity: (end.x + 1) * (end.y + 1))
            toVisit[start] = 0
            while let (current, distance) = toVisit.min(by: { $0.value < $1.value }) {
                if current == end {
                    return distance
                }
                visited[current] = distance
                toVisit.removeValue(forKey: current)
                for neighbor in current.adjacents() where !visited.contains(where: { $0.key == neighbor }) {
                    guard let risk = getRisk(at: neighbor, fullMap: fullMap) else {
                        continue
                    }
                    let nextDistance = distance + risk
                    if toVisit[neighbor] == nil || nextDistance < toVisit[neighbor].unsafelyUnwrapped {
                        toVisit[neighbor] = nextDistance
                    }
                }
            }
            throw Errors.unsolvable
        }

        func getRisk(at position: Vector2D, fullMap: Bool) -> Int? {
            if !fullMap {
                return risks[position]
            }
            let times = 5
            guard let risk = risks[.init(x: position.x % (end.x + 1), y: position.y % (end.y + 1))] else {
                return nil
            }
            // Add one for each time we overflow, with a limit of 5
            let overflowX = position.x / (end.x + 1)
            let overflowY = position.y / (end.y + 1)
            if overflowX >= times || overflowY >= times {
                return nil
            }
            var calculatedRisk = risk + overflowX + overflowY
            while calculatedRisk > 9 {
                calculatedRisk -= 9
            }
            return calculatedRisk
        }

        static func parse(input: String) throws -> Cave {
            var risks: [Vector2D: Int] = [:]
            var maxX: Int = 0
            var maxY: Int = 0
            for (y, line) in input.components(separatedBy: .newlines).enumerated() where !line.isEmpty {
                for (x, char) in line.enumerated() {
                    guard let risk = Int("\(char)") else {
                        throw Errors.unparsable
                    }
                    risks[.init(x: x, y: y)] = risk
                    maxX = max(maxX, x)
                }
                maxY = max(maxY, y)
            }
            return .init(risks: risks, end: .init(x: maxX, y: maxY))
        }
    }
}
