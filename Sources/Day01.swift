// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day01: AdventDay {
    let data: String

    private var input: (lhs: [Int], rhs: [Int]) {
        data
            .split(separator: "\n")
            .reduce(into: ([Int](), [Int]())) { partialResult, row in
                let values = row.split(separator: "   ")
                guard let leftValue = Int(values[0]), let rightValue = Int(values[1]) else {
                    fatalError("Invalid input: \(row)")
                }

                partialResult.0.append(leftValue)
                partialResult.1.append(rightValue)
            }
    }

    // Benchmark: 0.004215291 seconds
    func part1() -> Int {
        let input = input
        let listOne = input.lhs.sorted()
        let listTwo = input.rhs.sorted()
        return listOne.enumerated().reduce(into: 0) { partialResult, item in
            let (index, listOneValue) = item
            let listTwoValue = listTwo[index]
            partialResult += max(listOneValue, listTwoValue) - min(listOneValue, listTwoValue)
        }
    }

    // Benchmark: 0.004064375 seconds
    func part2() -> Int {
        let (listOne, listTwo) = input
        // Map list two into a dictionary of counts.
        let listTwoValues = listTwo.reduce(into: [Int: Int]()) { partialResult, value in
            partialResult[value] = (partialResult[value] ?? 0) + 1
        }

        return listOne.reduce(into: 0) { partialResult, value in
            partialResult += (listTwoValues[value] ?? 0) * value
        }
    }
}
