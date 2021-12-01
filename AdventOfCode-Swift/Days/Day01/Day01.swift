
import Foundation

struct Day01: Day {
    static func test() throws {
        let numbers = [199, 200, 208, 210, 200, 207, 240, 269, 260, 263]
        let increases = numberOfIncreases(for: numbers)
        precondition(increases == 7, "Day 1-1 precondition")
        let windowedNumbers = convertToMeasurementSlidingWindow(from: numbers)
        let windowedIncreases = numberOfIncreases(for: windowedNumbers)
        precondition(windowedIncreases == 5, "Day 1-2 precondition")
    }

    static func run(input: String) throws {
        let numbers = try integers(from: input)
        let increases = numberOfIncreases(for: numbers)
        print("Number of increases for Day 1-1 is \(increases)")
        let windowedNumbers = convertToMeasurementSlidingWindow(from: numbers)
        let windowedIncreases = numberOfIncreases(for: windowedNumbers)
        print("Number of increases for Day 1-2 is \(windowedIncreases)")
    }

    static func numberOfIncreases(for numbers: [Int]) -> Int {
        enum Measurement {
            case undefined, increased, decreased, equals
        }
        var previous: Int?
        var measurements: [Measurement] = []
        for number in numbers {
            defer {
                previous = number
            }
            guard let previous = previous else {
                measurements.append(.undefined)
                continue
            }
            if previous == number {
                measurements.append(.equals)
            } else if previous < number {
                measurements.append(.increased)
            } else if previous > number {
                measurements.append(.decreased)
            } else {
                fatalError("Undefined behavior")
            }
        }
        return measurements.count(where: { $0 == .increased })
    }

    static func convertToMeasurementSlidingWindow(from numbers: [Int], window: Int = 3) -> [Int] {
        var windowed: [Int] = []
        for index in 0...(numbers.count-window) {
            windowed.append(numbers[index...index+2].reduce(0, +))
        }
        return windowed
    }
}
