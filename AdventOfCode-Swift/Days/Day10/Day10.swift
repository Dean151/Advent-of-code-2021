
import Foundation

struct Day10: Day {
    static func test() throws {
        precondition(try! Result.analyse(line: "[]") == .valid)
        precondition(try! Result.analyse(line: "([])") == .valid)
        precondition(try! Result.analyse(line: "{()()()}") == .valid)
        precondition(try! Result.analyse(line: "<([{}])>") == .valid)
        precondition(try! Result.analyse(line: "[<>({}){}[([])<>]]") == .valid)
        precondition(try! Result.analyse(line: "(((((((((())))))))))") == .valid)
        precondition(try! Result.analyse(line: "{([(<{}[<>[]}>{[]{[(<()>") == .corrupted(expected: .bracket, found: .accolade))
        precondition(try! Result.analyse(line: "[[<[([]))<([[{}[[()]]]") == .corrupted(expected: .bracket, found: .parenthesis))
        precondition(try! Result.analyse(line: "[{[{({}]{}}([{[{{{}}([]") == .corrupted(expected: .parenthesis, found: .bracket))
        precondition(try! Result.analyse(line: "[<(<(<(<{}))><([]([]()") == .corrupted(expected: .tag, found: .parenthesis))
        precondition(try! Result.analyse(line: "<{([([[(<>()){}]>(<<{{") == .corrupted(expected: .bracket, found: .tag))
        let testInput = """
[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]
"""
        let corruptionScore = try calculateCorruption(for: testInput)
        precondition(corruptionScore == 26397)
        let incompletionScore = try calculateIncompletion(for: testInput)
        precondition(incompletionScore == 288957)
    }

    static func run(input: String) throws {
        let corruptionScore = try calculateCorruption(for: input)
        print("Corruption score for Day 10-1 is \(corruptionScore)")
        let incompletionScore = try calculateIncompletion(for: input)
        print("Incompletion score for Day 10-2 is \(incompletionScore)")
    }

    static func calculateCorruption(for input: String) throws -> Int {
        var score = 0
        for line in input.components(separatedBy: .newlines) where !line.isEmpty {
            switch try Result.analyse(line: line) {
            case .valid, .incomplete:
                break
            case .corrupted(expected: _, found: let found):
                score += found.corruptionScore
            }
        }
        return score
    }

    static func calculateIncompletion(for input: String) throws -> Int {
        var scores: [Int] = []
        for line in input.components(separatedBy: .newlines) where !line.isEmpty {
            switch try Result.analyse(line: line) {
            case .valid, .corrupted:
                break
            case .incomplete(expected: let expectedChunks):
                var score = 0
                for expected in expectedChunks {
                    score *= 5
                    score += expected.incompletionScore
                }
                scores.append(score)
            }
        }
        return scores.sorted()[scores.count / 2]
    }

    enum Chunk {
        enum Direction {
            case opening, closing
        }

        case parenthesis // ()
        case bracket // []
        case accolade // {}
        case tag // <>

        var corruptionScore: Int {
            switch self {
            case .parenthesis:
                return 3
            case .bracket:
                return 57
            case .accolade:
                return 1197
            case .tag:
                return 25137
            }
        }

        var incompletionScore: Int {
            switch self {
            case .parenthesis:
                return 1
            case .bracket:
                return 2
            case .accolade:
                return 3
            case .tag:
                return 4
            }
        }

        static func from(char: Character) throws -> (Chunk, Chunk.Direction) {
            switch char {
            case "(":
                return (.parenthesis, .opening)
            case "[":
                return (.bracket, .opening)
            case "{":
                return (.accolade, .opening)
            case "<":
                return (.tag, .opening)
            case ")":
                return (.parenthesis, .closing)
            case "]":
                return (.bracket, .closing)
            case "}":
                return (.accolade, .closing)
            case ">":
                return (.tag, .closing)
            default:
                throw Errors.unparsable
            }
        }
    }

    enum Result: Equatable {
        case valid
        case corrupted(expected: Chunk, found: Chunk)
        case incomplete(expected: [Chunk])

        static func analyse(line: String) throws -> Result {
            var expectations: [Chunk] = []
            for char in line {
                let found = try Chunk.from(char: char)
                switch found.1 {
                case .opening:
                    // We open a new chunk, add an expectation
                    expectations.append(found.0)
                case .closing:
                    // We close a chunk, let's hope it's an expected one :)
                    if let expected = expectations.popLast() {
                        if expected != found.0 {
                            return .corrupted(expected: expected, found: found.0)
                        }
                    } else {
                        // No more expectations???
                        throw Errors.unsolvable
                    }
                }
            }
            return expectations.isEmpty ? .valid : .incomplete(expected: expectations.reversed())
        }

        static func ==(lhs: Result, rhs: Result) -> Bool {
            switch lhs {
            case .valid:
                if case .valid = rhs {
                    return true
                }
                return false
            case .corrupted(expected: let lexp, found: let lfound):
                if case .corrupted(expected: let rexp, found: let rfound) = rhs {
                    return lexp == rexp && lfound == rfound
                }
                return false
            case .incomplete(expected: let lexp):
                if case .incomplete(expected: let rexp) = rhs {
                    return lexp == rexp
                }
                return false
            }
        }
    }
}
