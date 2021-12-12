
import Foundation

struct Day12: Day {
    static func test() throws {
        let tenPathsInput = """
start-A
start-b
A-c
A-b
b-d
A-end
b-end
"""
        let nineteenPathsInput = """
dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc
"""
        let twoHundredTwentySixPathsInput = """
fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW
"""
        let tenPathsNetwork = try Network.from(input: tenPathsInput)
        let nineteenPathsNetwork = try Network.from(input: nineteenPathsInput)
        let twoHundredTwentySixPathsNetwork = try Network.from(input: twoHundredTwentySixPathsInput)
        let ten = try tenPathsNetwork.numberOfPaths()
        precondition(ten == 10)
        let nineteen = try nineteenPathsNetwork.numberOfPaths()
        precondition(nineteen == 19)
        let twoHundredTwentySix = try twoHundredTwentySixPathsNetwork.numberOfPaths()
        precondition(twoHundredTwentySix == 226)
        let thirstySix = try tenPathsNetwork.numberOfPaths(visitingOneSmallCaveTwice: true)
        precondition(thirstySix == 36)
        let hundredAndThree = try nineteenPathsNetwork.numberOfPaths(visitingOneSmallCaveTwice: true)
        precondition(hundredAndThree == 103)
        let threeThousandFiveHundredAndNine = try twoHundredTwentySixPathsNetwork.numberOfPaths(visitingOneSmallCaveTwice: true)
        precondition(threeThousandFiveHundredAndNine == 3509)
    }

    static func run(input: String) throws {
        let network = try Network.from(input: input)
        let numberOfPaths = try network.numberOfPaths()
        print("Number of valid paths for Day 12-1 is \(numberOfPaths)")
        let numberOfPathsExtended = try network.numberOfPaths(visitingOneSmallCaveTwice: true)
        print("Number of valid paths for Day 12-2 is \(numberOfPathsExtended)")
    }

    struct Network {
        class Cave: Equatable, Hashable {
            enum Size {
                case big, small
            }
            let identifier: String
            let size: Size
            var connexions: Set<Cave> = []

            init(identifier: String) {
                self.identifier = identifier
                self.size = identifier.lowercased() == identifier ? .small : .big
            }

            /// Hashable
            func hash(into hasher: inout Hasher) {
                hasher.combine(identifier)
            }

            /// Equatable
            static func == (lhs: Cave, rhs: Cave) -> Bool {
                lhs.identifier == rhs.identifier
            }
        }

        let caves: [String: Cave]

        func numberOfPaths(visitingOneSmallCaveTwice: Bool = false) throws -> Int {
            guard let start = caves["start"], let end = caves["end"] else {
                throw Errors.unsolvable
            }
            var toDequeue = [([start], false)]
            var completed: [[Cave]] = []
            while let (path, alreadyVisitedSmallCaveTwice) = toDequeue.popLast() {
                guard let current = path.last else {
                    throw Errors.unsolvable
                }
                for next in current.connexions where next != start {
                    let visitingSmallCaveASecondTime = next.size == .small && path.contains(next)
                    if visitingSmallCaveASecondTime {
                        if !visitingOneSmallCaveTwice || alreadyVisitedSmallCaveTwice {
                            // No right to go back to same small cave again
                            continue
                        }
                    }
                    var possiblePath = path
                    possiblePath.append(next)
                    if next == end {
                        completed.append(possiblePath)
                    } else {
                        toDequeue.append((possiblePath, alreadyVisitedSmallCaveTwice || visitingSmallCaveASecondTime))
                    }
                }
            }
            return completed.count
        }

        static func from(input: String) throws -> Network {
            var caves: [String: Cave] = [:]
            for line in input.components(separatedBy: .newlines) where !line.isEmpty {
                let identifiers = line.components(separatedBy: "-")
                guard identifiers.count == 2 else {
                    throw Errors.unparsable
                }
                func getOrMakeCave(identifier: String) -> Cave {
                    if let cave = caves[identifier] {
                        return cave
                    }
                    let cave = Cave(identifier: identifier)
                    caves[identifier] = cave
                    return cave
                }
                // Make the two way link
                let first = getOrMakeCave(identifier: identifiers[0])
                let second = getOrMakeCave(identifier: identifiers[1])
                first.connexions.insert(second)
                second.connexions.insert(first)
            }
            return .init(caves: caves)
        }
    }
}
