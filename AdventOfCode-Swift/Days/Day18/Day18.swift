
import Foundation

struct Day18: Day {
    static func test() throws {
        // Parse tests
        for line in [
            "[1,2]",
            "[[1,2],3]",
            "[9,[8,7]]",
            "[[1,9],[8,5]]",
            "[[[[1,2],[3,4]],[[5,6],[7,8]]],9]",
            "[[[9,[3,8]],[[0,9],6]],[[[3,7],[4,9]],3]]",
            "[[[[1,3],[5,3]],[[1,3],[8,7]]],[[[4,9],[6,9]],[[8,2],[7,3]]]]",
        ] {
            let number = try SnailfishNumber.parse(line: line)
            precondition(number.description == line, "Failed parse expectation to be \(line)")
        }

        // Magnitude tests
        for (line, expectedMagnitude) in [
            "[[1,2],[[3,4],5]]": 143,
            "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]": 1384,
            "[[[[1,1],[2,2]],[3,3]],[4,4]]": 445,
            "[[[[3,0],[5,3]],[4,4]],[5,5]]": 791,
            "[[[[5,0],[7,4]],[5,5]],[6,6]]": 1137,
            "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]": 3488,
        ] {
            let number = try SnailfishNumber.parse(line: line)
            precondition(number.magnitude == expectedMagnitude, "Failed magnitude to be \(expectedMagnitude)")
        }

        // Reduce tests
        for (expected, line) in [
            "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]": "[[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]]",
            "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]": "[[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]],[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]]"
        ] {
            let number = try SnailfishNumber.parse(line: line)
            number.reduce()
            precondition(number.description == expected, "Failed reduction: \(number.description) to be \(expected)")
        }

        // Sum tests
        for (expectedSum, input) in [
            "[[[[1,1],[2,2]],[3,3]],[4,4]]": """
[1,1]
[2,2]
[3,3]
[4,4]
""",
            "[[[[3,0],[5,3]],[4,4]],[5,5]]": """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
""",
            "[[[[5,0],[7,4]],[5,5]],[6,6]]": """
[1,1]
[2,2]
[3,3]
[4,4]
[5,5]
[6,6]
""",
        "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]": """
[[[[4,3],4],4],[7,[[8,4],9]]]
[1,1]
""",
            "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]": """
[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]
[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]
[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]
[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]
[7,[5,[[3,8],[1,4]]]]
[[2,[2,2]],[8,[8,1]]]
[2,9]
[1,[[[9,3],9],[[9,0],[0,7]]]]
[[[5,[7,4]],7],1]
[[[[4,2],2],6],[8,7]]
""",
            "[[[[7,8],[6,6]],[[6,0],[7,7]]],[[[7,8],[8,8]],[[7,9],[0,6]]]]": """
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
""",
        ] {
            let numbers = try SnailfishNumber.parse(input: input)
            let sum = try numbers.finalSum()
            precondition(sum.description == expectedSum, "Failed sum result \(sum.description) to be \(expectedSum)")
        }

        // Final test
        let input = """
[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
[[[5,[2,8]],4],[5,[[9,9],0]]]
[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]
[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]
[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]
[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]
[[[[5,4],[7,7]],8],[[8,3],8]]
[[9,3],[[9,9],[6,[4,9]]]]
[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]
[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]
"""
        let numbers = try SnailfishNumber.parse(input: input)
        let sum = try numbers.finalSum()
        let expectedSum = "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]"
        precondition(sum.description == expectedSum, "Failed sum result \(sum.description) to be \(expectedSum)")
        precondition(sum.magnitude == 4140)
        let numbersAgain = try SnailfishNumber.parse(input: input)
        let largestMagnitude = try numbersAgain.largestMagnitude()
        precondition(largestMagnitude == 3993)
    }


    static func run(input: String) throws {
        let numbers = try SnailfishNumber.parse(input: input)
        let finalSum = try numbers.finalSum()
        let magnitude = finalSum.magnitude
        print("Magnitude for Day 18-1 sum is \(magnitude)")
        let numbersAgain = try SnailfishNumber.parse(input: input)
        let largestMagnitude = try numbersAgain.largestMagnitude()
        print("Largest magnitude by adding two numbers for Day 18-2 is \(largestMagnitude)")
    }

    class SnailfishNumber: CustomStringConvertible {
        var value: Int = 0
        var pairs: (SnailfishNumber, SnailfishNumber)? = nil

        weak var parent: SnailfishNumber?

        var level: Int {
            guard let parent = parent else {
                return 1
            }
            return parent.level + 1
        }

        var description: String {
            if let (left, right) = pairs {
                return "[\(left.description),\(right.description)]"
            } else {
                return "\(value)"
            }
        }

        var magnitude: Int {
            if let (left, right) = pairs {
                return 3 * left.magnitude + 2 * right.magnitude
            } else {
                return value
            }
        }

        init(value: Int) {
            self.value = value
        }

        init(left: SnailfishNumber, right: SnailfishNumber) {
            left.parent = self
            right.parent = self
            self.pairs = (left, right)
        }

        func add(_ other: SnailfishNumber) throws -> SnailfishNumber {
            let number = SnailfishNumber(left: self, right: other)
            number.reduce()
            return number
        }

        func reduce() {
            while explode() || split() {}
        }

        /// Mutating with one explosion. And return true if exploded, false otherwise
        func explode() -> Bool {
            if let pairs = pairs {
                if level > 4 {
                    // Explosion! 💥
                    let (left, right) = pairs
                    value = 0
                    self.pairs = nil
                    let (leftLeaf, rightLeaf) = findNeighbors()
                    leftLeaf?.value += left.value
                    rightLeaf?.value += right.value
                    return true
                }
                // Left before
                return pairs.0.explode() || pairs.1.explode()
            }
            return false
        }

        func findNeighbors() -> (SnailfishNumber?, SnailfishNumber?) {
            // Go back to first parent
            var root: SnailfishNumber = self
            while let parent = root.parent {
                root = parent
            }

            // Go threw the tree finding self back.
            var previous: SnailfishNumber?
            var next: SnailfishNumber?
            var updatePrevious = true

            func traverse(_ number: SnailfishNumber) {
                guard let pairs = number.pairs else {
                    if number === self {
                        // Previous is the left
                        updatePrevious = false
                        // Next one is the right
                    } else if updatePrevious {
                        previous = number
                    } else if next == nil {
                        next = number
                    }
                    return
                }
                if next == nil {
                    traverse(pairs.0)
                    traverse(pairs.1)
                }
            }
            traverse(root)

            return (previous, next)
        }

        func split() -> Bool {
            guard let pairs = pairs else {
               if value > 9 {
                   let left = SnailfishNumber(value: Int(floor(Double(value) / 2)))
                   let right = SnailfishNumber(value: Int(ceil(Double(value) / 2)))
                   left.parent = self
                   right.parent = self
                   self.pairs = (left, right)
                   return true
               }
               return false
            }
            // Left before
            return pairs.0.split() || pairs.1.split()
        }

        static func parse(line: String) throws -> SnailfishNumber {
            if let value = Int(line) {
                return .init(value: value)
            }
            precondition(line.hasPrefix("[") && line.hasSuffix("]"))
            let inside = line.dropFirst().dropLast()
            var toClose = 0
            // Remove extremum [ & ] ; then find the comma that is outside every [] to split on ... And repeat!
            for (index, char) in inside.enumerated() {
                switch char {
                case ",":
                    if toClose == 0 {
                        // We have it!
                        let index = inside.index(inside.startIndex, offsetBy: index)
                        let left = String(inside[..<index])
                        let right = String(inside[inside.index(after: index)...])
                        return .init(left: try .parse(line: left), right: try .parse(line: right))
                    }
                case "[":
                    toClose += 1
                case "]":
                    toClose -= 1
                default:
                    break
                }
            }
            throw Errors.unparsable
        }

        static func parse(input: String) throws -> [SnailfishNumber] {
            try input.components(separatedBy: .newlines).filter({ !$0.isEmpty }).map({ try parse(line: $0) })
        }
    }
}

extension Array where Element == Day18.SnailfishNumber {
    func finalSum() throws -> Day18.SnailfishNumber {
        guard var result = first else {
            throw Errors.unsolvable
        }
        guard count > 1 else {
            return result
        }
        for number in self[1...] {
            result = try result.add(number)
        }
        return result
    }

    func largestMagnitude() throws -> Int {
        var maxMagnitude = 0
        for number in self {
            for other in self {
                if number === other {
                    continue
                }
                let magnitude = try Day18.SnailfishNumber.parse(input: "\(number)\n\(other)").finalSum().magnitude
                maxMagnitude = Swift.max(maxMagnitude, magnitude)
            }
        }
        return maxMagnitude
    }
}

