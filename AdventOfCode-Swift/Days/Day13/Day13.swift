
import Foundation

struct Day13: Day {
    static func test() throws {
        let input = """
6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5
"""
        var (paper, folds) = try TransparentPaper.from(input: input)
        let firstFold = folds.removeFirst()
        paper = paper.perform(firstFold)
        precondition(paper.dots.count == 17)
        paper = paper.perform(folds)
        precondition(paper.dots.count == 16)
    }

    static func run(input: String) throws {
        var (paper, folds) = try TransparentPaper.from(input: input)
        let firstFold = folds.removeFirst()
        paper = paper.perform(firstFold)
        print("Number of dots after first fold for Day 13-1 is \(paper.dots.count)")
        paper = paper.perform(folds)
        print("Code for Day 13-2 is:")
        paper.print()
    }

    struct TransparentPaper {
        enum Fold {
            case horizontal(x: Int)
            case vertical(y: Int)

            func transform(_ dot: Vector2D) -> Vector2D {
                switch self {
                case .horizontal(x: let x):
                    return dot.x > x ? .init(x: (2 * x) - dot.x, y: dot.y) : dot
                case .vertical(y: let y):
                    return dot.y > y ? .init(x: dot.x, y: (2 * y) - dot.y) : dot
                }
            }

            static func from(line: String) throws -> Fold {
                let components = line.components(separatedBy: "=")
                guard components.count == 2 else {
                    throw Errors.unparsable
                }
                guard let amount = Int(components[1]) else {
                    throw Errors.unparsable
                }
                switch components[0] {
                case "fold along x":
                    return .horizontal(x: amount)
                case "fold along y":
                    return .vertical(y: amount)
                default:
                    throw Errors.unparsable
                }
            }
        }

        var dots: Set<Vector2D>

        func perform(_ fold: Fold) -> TransparentPaper {
            var afterDots: Set<Vector2D> = .init(minimumCapacity: dots.count)
            for dot in dots {
                afterDots.insert(fold.transform(dot))
            }
            return .init(dots: afterDots)
        }

        func perform(_ folds: [Fold]) -> TransparentPaper {
            var paper = self
            for fold in folds {
                paper = paper.perform(fold)
            }
            return paper
        }

        func print() {
            dots.print(present: "█", absent: " ")
        }

        static func from(input: String) throws -> (TransparentPaper, [Fold]) {
            var dots: Set<Vector2D> = []
            var folds: [Fold] = []
            for line in input.components(separatedBy: .newlines) where !line.isEmpty {
                guard let vector = try? Vector2D.from(string: line) else {
                    // Probably a fold
                    folds.append(try Fold.from(line: line))
                    continue
                }
                dots.insert(vector)
            }
            return (.init(dots: dots), folds)
        }
    }
}
