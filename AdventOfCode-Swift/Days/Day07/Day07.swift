
import Foundation

struct Day07: Day {
    static func test() throws {
        let testInput = "16,1,2,0,4,2,7,1,2,14"
        let numbers = try integers(from: testInput, separatedBy: .punctuationCharacters)
        let fuelMedian = try fuelUsedConstant(with: numbers)
        precondition(fuelMedian == 37)
        let fuelMean = try fuelUsedLinear(with: numbers)
        precondition(fuelMean == 168)
    }

    static func run(input: String) throws {
        let numbers = try integers(from: input, separatedBy: .punctuationCharacters)
        let fuelMedian = try fuelUsedConstant(with: numbers)
        print("Least fuel used for Day 7-1 is \(fuelMedian)")
        let fuelMean = try fuelUsedLinear(with: numbers)
        print("Realistic least fuel used for Day 7-2 is \(fuelMean)")

    }

    static func fuelUsedConstant(with positions: [Int]) throws -> Int {
        let median = positions.sorted()[positions.count / 2]
        return positions.reduce(0, { $0 + abs($1 - median) })
    }

    static func fuelUsedLinear(with positions: [Int]) throws -> Int {
        let mean = positions.reduce(0, +) / positions.count
        let fuel = positions.reduce(0, { $0 + sumOfIntegers(upTo: abs($1 - mean)) })
        let fuelBefore = positions.reduce(0, { $0 + sumOfIntegers(upTo: abs($1 - (mean-1))) })
        let fuelAfter = positions.reduce(0, { $0 + sumOfIntegers(upTo: abs($1 - (mean+1))) })
        return min(fuelBefore, fuel, fuelAfter)
    }
}
