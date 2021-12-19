
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
"""
        ] {
            let numbers = try SnailfishNumber.parse(input: input)
            let sum = try numbers.finalSum()
            precondition(sum.description == expectedSum, "Failed sum expectation to be \(expectedSum)")
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
        let number = try SnailfishNumber.parse(input: input)
        let sum = try number.finalSum()
        precondition(sum.description == "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
        precondition(sum.magnitude == 4140)
    }


    static func run(input: String) throws {
        let numbers = try SnailfishNumber.parse(input: input)
        let finalSum = try numbers.finalSum()
        let magnitude = finalSum.magnitude
        print("Magnitude for Day 18-1 sum is \(magnitude)")
    }

    indirect enum SnailfishNumber: Equatable {
        case half(value: Int)
        case pair(leftPart: SnailfishNumber, rightPath: SnailfishNumber)

        var description: String {
            switch self {
            case .half(value: let value):
                return "\(value)"
            case .pair(leftPart: let left, rightPath: let right):
                return "[\(left.description),\(right.description)]"
            }
        }

        var magnitude: Int {
            switch self {
            case .half(value: let value):
                return value
            case .pair(leftPart: let left, rightPath: let right):
                return 3 * left.magnitude + 2 * right.magnitude
            }
        }

        mutating func adding(_ other: SnailfishNumber) throws {
            self = .pair(leftPart: self, rightPath: other)
            // TODO: reduce! explode! split!
        }

        static func parse(line: String) throws -> SnailfishNumber {
            if let value = Int(line) {
                return .half(value: value)
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
                        return .pair(leftPart: try .parse(line: left), rightPath: try .parse(line: right))
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

        static func == (lhs: SnailfishNumber, rhs: SnailfishNumber) -> Bool {
            switch lhs {
            case .half(value: let left):
                switch rhs {
                case .half(value: let right):
                    return left == right
                default:
                    return false
                }
            case .pair(leftPart: let leftLeft, rightPath: let leftRight):
                switch rhs {
                case .pair(leftPart: let rightLeft, rightPath: let rightRight):
                    return leftLeft == rightLeft && leftRight == rightRight
                default:
                    return false
                }
            }
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
            try result.adding(number)
        }
        return result
    }
}
