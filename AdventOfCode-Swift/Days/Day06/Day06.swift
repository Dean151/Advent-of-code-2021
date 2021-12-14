
import Foundation

struct Day06: Day {
    static func test() throws {
        let testInput = "3,4,3,1,2"
        let lanternfishs = try Lanternfishs.from(input: testInput)
        precondition(lanternfishs.number(after: 18) == 26)
        precondition(lanternfishs.number(after: 80) == 5934)
        precondition(lanternfishs.number(after: 256) == 26984457539)
    }

    static func run(input: String) throws {
        let lanternfishs = try Lanternfishs.from(input: input)
        print("Number of fishes after 80 days is \(lanternfishs.number(after: 80)) for Day 6-1")
        print("Number of fishes after 256 days is \(lanternfishs.number(after: 256)) for Day 6-2")
    }

    struct Lanternfishs {
        let fishes: [Int: Int]

        func number(after days: Int) -> Int {
            var fishes = fishes
            for _ in 1...days {
                var toAddAndReset = 0
                for internalCounter in 0...8 {
                    if let count = fishes[internalCounter] {
                        if internalCounter == 0 {
                            toAddAndReset = count
                        } else {
                            fishes[internalCounter - 1] = count
                        }
                    } else {
                        fishes[internalCounter - 1] = 0
                    }
                }
                if let count = fishes[6] {
                    fishes[6] = count + toAddAndReset
                } else {
                    fishes[6] = toAddAndReset
                }
                fishes[8] = toAddAndReset
            }
            return fishes.reduce(0, { $0 + $1.value })
        }

        static func from(input: String) throws -> Lanternfishs {
            let integers = try Day06.integers(from: input, separatedBy: .punctuationCharacters)
            var fishes: [Int: Int] = [:]
            for integer in integers {
                fishes.increment(forKey: integer)
            }
            return .init(fishes: fishes)
        }
    }
}
