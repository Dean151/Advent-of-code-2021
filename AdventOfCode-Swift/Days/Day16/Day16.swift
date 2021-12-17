
import Foundation

struct Day16: Day {
    static func test() throws {
        let first = "D2FE28"
        let firstPacket = try Packet.parse(input: first)
        precondition(firstPacket == .literal(version: 6, value: 2021))
        let second = "38006F45291200"
        let secondPacket = try Packet.parse(input: second)
        precondition(secondPacket == .operator(version: 1, type: .lessThan, subpackets: [
            .literal(version: 6, value: 10),
            .literal(version: 2, value: 20),
        ]))
        let third = "EE00D40C823060"
        let thirdPacket = try Packet.parse(input: third)
        precondition(thirdPacket == .operator(version: 7, type: .maximum, subpackets: [
            .literal(version: 2, value: 1),
            .literal(version: 4, value: 2),
            .literal(version: 1, value: 3),
        ]))
        let firstSum = try Packet.parse(input: "8A004A801A8002F478").sumOfVersions
        precondition(firstSum == 16)
        let secondSum = try Packet.parse(input: "620080001611562C8802118E34").sumOfVersions
        precondition(secondSum == 12)
        let thirdSum = try Packet.parse(input: "C0015000016115A2E0802F182340").sumOfVersions
        precondition(thirdSum == 23)
        let fourthSum = try Packet.parse(input: "A0016C880162017C3686B18A3D4780").sumOfVersions
        precondition(fourthSum == 31)

        let firstValue = try Packet.parse(input: "C200B40A82").value
        precondition(firstValue == 3)
        let secondValue = try Packet.parse(input: "04005AC33890").value
        precondition(secondValue == 54)
        let thirdValue = try Packet.parse(input: "880086C3E88112").value
        precondition(thirdValue == 7)
        let fourthValue = try Packet.parse(input: "CE00C43D881120").value
        precondition(fourthValue == 9)
        let fifthValue = try Packet.parse(input: "D8005AC2A8F0").value
        precondition(fifthValue == 1)
        let sixthValue = try Packet.parse(input: "F600BC2D8F").value
        precondition(sixthValue == 0)
        let seventhValue = try Packet.parse(input: "9C005AC2F8F0").value
        precondition(seventhValue == 0)
        let heighthValue = try Packet.parse(input: "9C0141080250320F1802104A08").value
        precondition(heighthValue == 1)
    }

    static func run(input: String) throws {
        let packet = try Packet.parse(input: input)
        print("Sum of versions for Day 16-1 is \(packet.sumOfVersions)")
        print("Value for Day 16-2 is \(packet.value)")
    }

    enum Packet: Equatable {
        enum Operator: UInt {
            case sum = 0
            case product = 1
            case minimum = 2
            case maximum = 3
            case greaterThan = 5
            case lessThan = 6
            case equalsTo = 7

            func evaluate(with packets: [Packet]) -> UInt {
                let values = packets.map { $0.value }
                switch self {
                case .sum:
                    return values.reduce(0, +)
                case .product:
                    return values.reduce(1, *)
                case .minimum:
                    return values.min().unsafelyUnwrapped
                case .maximum:
                    return values.max().unsafelyUnwrapped
                case .greaterThan:
                    precondition(values.count == 2)
                    return values[0] > values[1] ? 1 : 0
                case .lessThan:
                    precondition(values.count == 2)
                    return values[0] < values[1] ? 1 : 0
                case .equalsTo:
                    precondition(values.count == 2)
                    return values[0] == values[1] ? 1 : 0
                }
            }
        }

        case literal(version: UInt, value: UInt)
        case `operator`(version: UInt, type: Operator, subpackets: [Packet])

        var version: UInt {
            switch self {
            case .literal(version: let version, value: _), .operator(version: let version, type: _, subpackets: _):
                return version
            }
        }

        var sumOfVersions: UInt {
            switch self {
            case .literal:
                return version
            case .operator(_, _, let subpackets):
                return subpackets.map({ $0.sumOfVersions }).reduce(version, +)
            }
        }

        var value: UInt {
            switch self {
            case .literal(version: _, value: let value):
                return value
            case .operator(version: _, type: let operation, subpackets: let packets):
                return operation.evaluate(with: packets)
            }
        }

        static func == (lhs: Packet, rhs: Packet) -> Bool {
            switch lhs {
            case .literal(let lhsversion, let lhsvalue):
                switch rhs {
                case .literal(let rhsversion, let rhsvalue):
                    return lhsversion == rhsversion && lhsvalue == rhsvalue
                default:
                    return false
                }
            case .operator(let lhsversion, let lhstype, let lhssubpackets):
                switch rhs {
                case .operator(let rhsversion, let rhstype, let rhssubpackets):
                    return lhsversion == rhsversion && lhstype == rhstype && lhssubpackets == rhssubpackets
                default:
                    return false
                }
            }
        }

        static func parse(input: String) throws -> Packet {
            let binary = try input.map { hex in
                switch hex {
                case "0":
                    return "0000"
                case "1":
                    return "0001"
                case "2":
                    return "0010"
                case "3":
                    return "0011"
                case "4":
                    return "0100"
                case "5":
                    return "0101"
                case "6":
                    return "0110"
                case "7":
                    return "0111"
                case "8":
                    return "1000"
                case "9":
                    return "1001"
                case "A", "a":
                    return "1010"
                case "B", "b":
                    return "1011"
                case "C", "c":
                    return "1100"
                case "D", "d":
                    return "1101"
                case "E", "e":
                    return "1110"
                case "F", "f":
                    return "1111"
                default:
                    throw Errors.unparsable
                }
            }.joined()
            let bits = try [Bit].from(binary: binary)
            return parse(bits: bits).packet
        }

        static func parse(bits: [Bit]) -> (packet: Packet, leftover: [Bit]) {
            // First three are version
            let version = bits[0..<3].decimal
            // Next three are type
            let typeInt = bits[3..<6].decimal
            var leftover = Array(bits[6...])
            if typeInt == 4 {
                var value: [Bit] = []
                while true {
                    defer {
                        leftover.removeFirst(5)
                    }
                    let start = leftover.startIndex
                    value.append(contentsOf: leftover[start+1..<start+5])
                    if leftover.first == .zero {
                        break
                    }
                }
                return (.literal(version: version, value: value.decimal), leftover)
            }

            var subpackets: [Packet] = []
            let countType = leftover.first.unsafelyUnwrapped
            leftover.removeFirst()
            switch countType {
            case .zero:
                // Bits number mode
                let numberOfBits = Int(leftover[0..<15].decimal)
                var bits = Array(leftover[15..<15+numberOfBits])
                leftover.removeFirst(numberOfBits + 15)
                while bits.contains(.one) {
                    let (packet, left) = Packet.parse(bits: bits)
                    subpackets.append(packet)
                    bits = left
                }
                break
            case .one:
                // Number of packets mode
                let numberOfPackets = Int(leftover[0..<11].decimal)
                leftover.removeFirst(11)
                while subpackets.count != numberOfPackets {
                    let (packet, left) = Packet.parse(bits: leftover)
                    subpackets.append(packet)
                    leftover = left
                }
            }
            return (.operator(version: version, type: Operator(rawValue: typeInt).unsafelyUnwrapped, subpackets: subpackets), leftover)
        }
    }
}
