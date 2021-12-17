
import Foundation

struct Day03: Day {
    static func test() throws {
        let testInput = "00100\n11110\n10110\n10111\n10101\n01111\n00111\n11100\n10000\n11001\n00010\n01010"
        let testNumbers = try from(input: testInput)
        let (gamma, epsilon) = gammaAndEpsilon(for: testNumbers)
        precondition(gamma.decimal == 22)
        precondition(epsilon.decimal == 9)
        let (oxygenGenerator, CO2Scrubber) = try oxygenGeneratorAndCO2Scrubber(for: testNumbers)
        precondition(oxygenGenerator.decimal == 23)
        precondition(CO2Scrubber.decimal == 10)
    }

    static func run(input: String) throws {
        let numbers = try from(input: input)
        let (gamma, epsilon) = gammaAndEpsilon(for: numbers)
        print("Gamma is \(gamma.decimal) and epsilon is \(epsilon.decimal) for Day 3-1, producing the result \(gamma.decimal * epsilon.decimal)")
        let (oxygenGenerator, CO2Scrubber) = try oxygenGeneratorAndCO2Scrubber(for: numbers)
        print("Oxygen Generator is \(oxygenGenerator.decimal) and CO2 Scrubber is \(CO2Scrubber.decimal) for Day 3-1, producing the result \(oxygenGenerator.decimal * CO2Scrubber.decimal)")
    }

    static func gammaAndEpsilon(for numbers: [[Bit]]) -> (gamma: [Bit], epsilon: [Bit]) {
        assert(numbers.count > 0)
        var gamma: [Bit] = []
        for index in 0..<numbers[0].count {
            gamma.append(numbers.map({ $0[index] }).count(where: { $0 == .one }) > (numbers.count / 2) ? .one : .zero)
        }
        let epsilon = gamma.inverted
        return (gamma, epsilon)
    }

    static func oxygenGeneratorAndCO2Scrubber(for numbers: [[Bit]]) throws -> (oxygenGenerator: [Bit], CO2Scrubber: [Bit]) {
        func process(numbers: [[Bit]], mostCommon: Bool, at index: Int = 0) throws -> [Bit] {
            if numbers.count == 1 {
                return numbers[0]
            }
            let length = numbers[0].count
            if numbers.isEmpty || index >= length {
                throw Errors.unsolvable
            }
            let bitIndex = length - index - 1
            let numberOfOnes = numbers.map({ $0[bitIndex] }).count(where: { $0 == .one })
            let numberOfZeros = numbers.count - numberOfOnes
            let bitToKeep: Bit
            if numberOfOnes < numberOfZeros {
                bitToKeep = mostCommon ? .zero : .one
            } else {
                bitToKeep = mostCommon ? .one : .zero
            }
            return try process(numbers: numbers.filter({ $0[bitIndex] == bitToKeep }), mostCommon: mostCommon, at: index + 1)
        }
        // TODO: we can do both in the same loop...
        let oxygenGenerator = try process(numbers: numbers, mostCommon: true)
        let CO2Scrubber = try process(numbers: numbers, mostCommon: false)
        return (oxygenGenerator, CO2Scrubber)
    }

    static func from(input: String) throws -> [[Bit]] {
        try input.components(separatedBy: .newlines).map({ try .from(binary: $0).reversed() })
    }
}
