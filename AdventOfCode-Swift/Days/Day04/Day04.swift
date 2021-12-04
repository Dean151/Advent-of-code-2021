
import Foundation

struct Day04: Day {
    static func test() throws {
        let testInput = """
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
"""
        let testBingo = try Bingo.parse(input: testInput)
        let (winner, lastDrawn) = try testBingo.winningBoard()
        precondition(lastDrawn == 24)
        precondition(winner.score == 188)
        let (loser, lastDrawnLoser) = try testBingo.winningBoard(lastToWin: true)
        precondition(lastDrawnLoser == 13)
        precondition(loser.score == 148)
    }

    static func run(input: String) throws {
        let bingo = try Bingo.parse(input: input)
        let (winner, lastDrawn) = try bingo.winningBoard()
        let score = winner.score
        print("Winning board won with number \(lastDrawn) and a score of \(score) giving \(score * lastDrawn) for Day 4-1")
        let (loser, lastDrawnLoser) = try bingo.winningBoard(lastToWin: true)
        let loserScore = loser.score
        print("Loosing board won with number \(lastDrawnLoser) and a score of \(loserScore) giving \(loserScore * lastDrawnLoser) for Day 4-2")
    }

    struct Bingo {
        struct Board {
            var numbers: Set<Int>
            var lines: [Set<Int>]
            var columns: [Set<Int>]

            mutating func drawed(number: Int) {
                if !numbers.contains(number) {
                    return
                }
                numbers.remove(number)
                for i in 0..<5 {
                    lines[i].remove(number)
                    columns[i].remove(number)
                }
            }

            var isWinner: Bool {
                return !lines.filter({ $0.isEmpty }).isEmpty || !columns.filter({ $0.isEmpty }).isEmpty
            }

            var score: Int {
                return numbers.reduce(0, +)
            }

            static func parse(section: String) throws -> Board {
                var numbers: Set<Int> = []
                var lines: [Set<Int>] = [[], [], [], [], []]
                var columns: [Set<Int>] = [[], [], [], [], []]
                for (row, line) in section.components(separatedBy: .newlines).enumerated() {
                    for (column, number) in line.components(separatedBy: .whitespaces).compactMap({ Int($0) }).enumerated() {
                        if numbers.contains(number) {
                            throw Errors.unparsable
                        }
                        numbers.insert(number)
                        lines[row].insert(number)
                        columns[column].insert(number)
                    }
                }
                return .init(numbers: numbers, lines: lines, columns: columns)
            }
        }

        let draw: [Int]
        let boards: [Board]

        func winningBoard(lastToWin: Bool = false) throws -> (board: Board, lastDraw: Int) {
            var boards = boards
            var drawn = draw
            var drawed: [Int] = []

            @discardableResult
            func drawNumber() throws -> Board? {
                let number = drawn.removeFirst()
                drawed.append(number)

                for (index, board) in boards.enumerated() {
                    var board = board
                    board.drawed(number: number)
                    boards[index] = board
                }

                let winners = boards.enumerated().filter({ $0.element.isWinner })
                if !winners.isEmpty {
                    for winner in winners.reversed() {
                        if !lastToWin {
                            return winner.element
                        }
                        boards.remove(at: winner.offset)
                        if boards.isEmpty || drawn.isEmpty {
                            return winner.element
                        }
                    }
                }
                return nil
            }

            // Draw the first four numbers, always non-winning
            for _ in 1...4 {
                try drawNumber()
            }

            var winner: Board?
            repeat {
                winner = try drawNumber()
            } while (winner == nil)

            return (winner.unsafelyUnwrapped, drawed.last.unsafelyUnwrapped)
        }

        static func parse(input: String) throws -> Bingo {
            var sections = input.components(separatedBy: "\n\n")
            // First section is about draw
            let first = sections.removeFirst()
            let draw = first.components(separatedBy: ",").compactMap({ Int($0) })

            // Next sections are boards
            let boards = try sections.map({ try Board.parse(section: $0) })
            return Bingo(draw: draw, boards: boards)
        }
    }
}
