
import Foundation

struct Day08: Day {
    static func test() throws {
        let testInput = """
be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
"""
        let numberOfSignificantNumbers = try numberOf1478(in: testInput)
        precondition(numberOfSignificantNumbers == 26)
        let simpleExample = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
        let decodedOutput = try decodeOutput(for: simpleExample)
        precondition(decodedOutput == 5353)
        let sum = try sumOfOutputs(for: testInput)
        precondition(sum == 61229)
    }

    static func run(input: String) throws {
        print("Number of significant numbers in outputs for Day 8-1 is \(try numberOf1478(in: input))")
        print("Sum of decoded output for Day 8-2 is \(try sumOfOutputs(for: input))")
    }

    static func numberOf1478(in input: String) throws -> Int {
        var count = 0
        for line in input.components(separatedBy: .newlines) where !line.isEmpty {
            let components = line.components(separatedBy: " | ")
            guard components.count == 2 else {
                throw Errors.unparsable
            }
            let output = components[1]
            count += output.components(separatedBy: .whitespaces).count(where: { [2, 3, 4, 7].contains($0.count) })
        }
        return count
    }

    static func sumOfOutputs(for input: String) throws -> Int {
        try input.components(separatedBy: .newlines).map({ try decodeOutput(for: $0) }).reduce(0, +)
    }

    static func decodeOutput(for line: String) throws -> Int {
        let components = line.components(separatedBy: " | ")
        guard components.count == 2 else {
            throw Errors.unparsable
        }
        let codedOutput = components[1].components(separatedBy: .whitespaces).map({ Set($0) })
        var codedNumbers = components[0].components(separatedBy: .whitespaces).map({ Set($0) }) + codedOutput

        // Find the easy ones
        let one = codedNumbers.first(where: { $0.count == 2 }).unsafelyUnwrapped
        let seven = codedNumbers.first(where: { $0.count == 3 }).unsafelyUnwrapped
        let four = codedNumbers.first(where: { $0.count == 4 }).unsafelyUnwrapped
        let eight = codedNumbers.first(where: { $0.count == 7 }).unsafelyUnwrapped
        codedNumbers.removeAll(where: { [2, 3, 4, 7].contains($0.count) })
        // 0, 6, 9 have 6 facets
        var sixFacets = codedNumbers.filter({ $0.count == 6 })
        // 0 is the only one of 6 facets that do not contains 4 minus 1
        let zero = sixFacets.first(where: { !$0.isSuperset(of: four.subtracting(one)) }).unsafelyUnwrapped
        sixFacets.removeAll(where: { $0 == zero })
        // Then 9 is the one that contains the 1 ; and the 6 is the remaining one
        let nine = sixFacets.first(where: { $0.isSuperset(of: one) }).unsafelyUnwrapped
        sixFacets.removeAll(where: { $0 == nine })
        let six = sixFacets.first.unsafelyUnwrapped
        // 2, 3, 5 have 5 facets
        var fiveFacets = codedNumbers.filter({ $0.count == 5 })
        // 3 is the only one that contains 1
        let three = fiveFacets.first(where: { $0.isSuperset(of: one) }).unsafelyUnwrapped
        fiveFacets.removeAll(where: { $0 == three })
        // 5 is contained by 9, and 2 is the remaining one
        let five = fiveFacets.first(where: { $0.isSubset(of: nine) }).unsafelyUnwrapped
        fiveFacets.removeAll(where: { $0 == five })
        let two = fiveFacets.first.unsafelyUnwrapped
        let numbers = [zero, one, two, three, four, five, six, seven, eight, nine]

        var output = 0
        for (index, coded) in codedOutput.enumerated() {
            let digit = numbers.firstIndex(of: coded).unsafelyUnwrapped
            output += digit * (10 ^^ (3 - index))
        }
        return output
    }
}
