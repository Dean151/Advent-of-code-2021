
import Foundation

struct Day14: Day {
    static func test() throws {
        let testInput = """
NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C
"""
        // Use precondition or assert to tests things
        let initial = try Polymer.parse(testInput)
        let polymer = try initial.after(steps: 10)
        let extremums = polymer.extremums.unsafelyUnwrapped
        precondition(extremums.min == 161)
        precondition(extremums.max == 1749)
        let strongest = try polymer.after(steps: 30)
        let bigExtremums = strongest.extremums.unsafelyUnwrapped
        precondition(bigExtremums.min == 3849876073)
        precondition(bigExtremums.max == 2192039569602)
    }

    static func run(input: String) throws {
        let initial = try Polymer.parse(input)
        let polymer = try initial.after(steps: 10)
        let extremums = polymer.extremums.unsafelyUnwrapped
        print("Result for Day 14-1 is \(extremums.max - extremums.min)")
        let strongest = try polymer.after(steps: 30)
        let bigExtremums = strongest.extremums.unsafelyUnwrapped
        print("Result for Day 14-2 is \(bigExtremums.max - bigExtremums.min)")
    }

    struct Polymer {
        let first: Character
        let last: Character
        let chain: [String: Int]
        let transforms: [String: String]

        var amounts: [Character: Int] {
            var amount = chain.reduce(into: [:]) { partialResult, element in
                element.key.forEach { char in
                    partialResult.increment(forKey: char, by: element.value)
                }
            }
            amount.increment(forKey: first)
            amount.increment(forKey: last)
            amount = amount.mapValues({ $0 / 2 })
            return amount
        }

        var extremums: (min: Int, max: Int)? {
            let amount = amounts
            guard let min = amount.min(by: { $0.value < $1.value }), let max = amount.max(by: { $0.value < $1.value }) else {
                return nil
            }
            return (min.value, max.value)
        }

        func after(steps n: Int = 1) throws -> Polymer {
            func newElements(from: String) throws -> [String] {
                guard let inserted = transforms[from] else {
                    throw Errors.unsolvable
                }
                return ["\(from.first.unsafelyUnwrapped)\(inserted)", "\(inserted)\(from.last.unsafelyUnwrapped)"]
            }

            var chain = self.chain
            for _ in 0..<n {
                chain = try chain.reduce(into: [:]) { partialResult, element in
                    (try newElements(from: element.key)).forEach { pattern in
                        partialResult.increment(forKey: pattern, by: element.value)
                    }
                }
            }
            return .init(first: first, last: last, chain: chain, transforms: transforms)
        }

        static func parse(_ input: String) throws -> Polymer {
            var lines = input.components(separatedBy: .newlines).filter({ !$0.isEmpty })

            // Parse first line a bit funny
            var chain: [String: Int] = [:]
            let firstLine = lines.removeFirst()
            let first = firstLine.first.unsafelyUnwrapped
            let last = firstLine.last.unsafelyUnwrapped
            var currentIndex = firstLine.startIndex
            while currentIndex < firstLine.index(before: firstLine.endIndex) {
                let nextIndex = firstLine.index(after: currentIndex)
                let pattern = "\(firstLine[currentIndex])\(firstLine[nextIndex])"
                chain.increment(forKey: pattern)
                currentIndex = nextIndex
            }

            var transforms: [String: String] = [:]
            for line in lines {
                let components = line.components(separatedBy: " -> ")
                guard components.count == 2 else {
                    throw Errors.unparsable
                }
                transforms[components[0]] = components[1]
            }
            return .init(first: first, last: last, chain: chain, transforms: transforms)
        }
    }
}
