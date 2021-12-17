
import Foundation

struct Day17: Day {
    static var input: String { "target area: x=29..73, y=-248..-194" }

    static func test() throws {
        let target = try Target.from(input: "target area: x=20..30, y=-10..-5")
        precondition(target == Target(minX: 20, minY: -10, maxX: 30, maxY: -5))
        let maxY = try target.findMaxY()
        precondition(maxY == 45)
        let count = target.findAllShotsCount(maxVy: maxY)
        precondition(count == 112)
    }

    static func run(input: String) throws {
        let target = try Target.from(input: input)
        let maxY = try target.findMaxY()
        print("Maximum Y we can reach for Day 17-1 is \(maxY)")
        let count = target.findAllShotsCount(maxVy: maxY)
        print("Count of different shots for Day 17-2 is \(count)")
    }

    struct Target: Equatable {
        let minX, minY, maxX, maxY: Int

        func findMaxY() throws -> Int {
            var vyInitial = abs(minY)
            main: repeat {
                var tempMaxY = 0
                var vy = vyInitial
                var y = 0
                while true {
                    y += vy
                    vy -= 1
                    tempMaxY = max(y, tempMaxY)
                    if (minY...maxY).contains(y) {
                        return tempMaxY
                    }
                    if y < minY {
                        vyInitial -= 1
                        continue main
                    }
                }
            } while vyInitial > 0
            throw Errors.unsolvable
        }

        func findAllShotsCount(maxVy: Int) -> Int {
            var count = 0
            for vyInitial in minY...maxVy {
                var haveHit = false
                for vxInitial in 1...maxX {
                    let velocity = Vector2D(x: vxInitial, y: vyInitial)
                    if willHit(with: velocity) {
                        count += 1
                        haveHit = true
                    } else if haveHit {
                        break
                    }
                }
            }
            return count
        }

        func willHit(with initialVelocity: Vector2D) -> Bool {
            var position: Vector2D = .zero
            var velocity = initialVelocity
            while true {
                position = position + velocity
                velocity.x = max(0, velocity.x - 1)
                velocity.y -= 1
                if contains(position) {
                    return true
                }
                if position.x > maxX || position.y < minY {
                    return false
                }
            }
        }

        func contains(_ position: Vector2D) -> Bool {
            return position.x >= minX && position.x <= maxX && position.y >= minY && position.y <= maxY
        }

        static func from(input: String) throws -> Target {
            let components = input.components(separatedBy: ", y=")
            let xs = components[0].components(separatedBy: "target area: x=")[1].components(separatedBy: "..").compactMap({ Int($0) })
            let ys = components[1].components(separatedBy: "..").compactMap({ Int($0) })
            precondition(xs.count == 2)
            precondition(ys.count == 2)
            return .init(
                minX: xs.min().unsafelyUnwrapped,
                minY: ys.min().unsafelyUnwrapped,
                maxX: xs.max().unsafelyUnwrapped,
                maxY: ys.max().unsafelyUnwrapped
            )
        }
    }
}
