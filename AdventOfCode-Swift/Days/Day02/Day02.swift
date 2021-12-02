
import Foundation

struct Day02: Day {
    private struct Submarine {
        struct Command {
            enum Direction: String {
                case forward, up, down
            }
            let direction: Direction
            let amount: Int

            static func from(line: String) throws -> Command {
                let components = line.components(separatedBy: .whitespaces)
                guard components.count == 2 else {
                    throw Errors.unparsable
                }
                guard let direction = components.first.flatMap({ Direction(rawValue: $0) }),
                        let amount = components.last.flatMap({ Int($0) }) else {
                    throw Errors.unparsable
                }
                return Command(direction: direction, amount: amount)
            }
        }

        static func commands(from input: String) throws -> [Command] {
            try input
                .components(separatedBy: .newlines)
                .filter({ !$0.isEmpty })
                .map({ try Command.from(line: $0) })
        }

        static func position(after commands: [Command]) -> (horizontal: Int, depth: Int) {
            let horizontal = commands.filter({ $0.direction == .forward }).reduce(0, { $0 + $1.amount })
            let depth = commands.filter({ $0.direction != .forward }).reduce(0, {
                return $1.direction == .up ? $0 - $1.amount : $0 + $1.amount
            })
            return (horizontal, depth)
        }

        static func positionWithAim(after command: [Command]) -> (horizontal: Int, depth: Int) {
            var horizontal = 0
            var depth = 0
            var aim = 0
            for command in command {
                switch command.direction {
                case .down:
                    aim += command.amount
                case .up:
                    aim -= command.amount
                case .forward:
                    horizontal += command.amount
                    depth += command.amount * aim
                }
            }
            return (horizontal, depth)
        }
    }

    static func test() throws {
        let testInput = "forward 5\ndown 5\nforward 8\nup 3\ndown 8\nforward 2\n"
        let testCommands = try Submarine.commands(from: testInput)
        precondition(testCommands.count == 6)
        let testPosition = Submarine.position(after: testCommands)
        precondition(testPosition.horizontal == 15)
        precondition(testPosition.depth == 10)
        let testPositionWithAim = Submarine.positionWithAim(after: testCommands)
        precondition(testPositionWithAim.horizontal == 15)
        precondition(testPositionWithAim.depth == 60)
    }

    static func run(input: String) throws {
        let commands = try Submarine.commands(from: input)
        let position = Submarine.position(after: commands)
        print("Final position for Day 2-1 is \(position) ; giving \(position.horizontal * position.depth) as solution")
        let positionWithAim = Submarine.positionWithAim(after: commands)
        print("Final position for Day 2-2 is \(positionWithAim) ; giving \(positionWithAim.horizontal * positionWithAim.depth) as solution")
    }
}
