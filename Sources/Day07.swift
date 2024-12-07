// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Algorithms

struct Day07: AdventDay {
    let data: String

    func part1() -> Int {
        getValidCount(applyConcatenation: false)
    }

    func part2() -> Int {
        getValidCount(applyConcatenation: true)
    }

    private func getValidCount(applyConcatenation: Bool) -> Int {
        var validCount = 0
        for row in data.split(separator: "\n") {
            let components = row.split(separator: ":")
            precondition(components.count == 2)
            let total = components[0].toInt()
            let numbers = components[1].split(separator: " ").map { $0.toInt() }
            precondition(!numbers.isEmpty)
            if isValid(numbers: numbers, total: total, applyConcatenation: applyConcatenation) {
                validCount += total
            }
        }

        return validCount
    }

    private func isValid(numbers: [Int], total: Int, applyConcatenation: Bool) -> Bool {
        var runningTotals: [Int] = [numbers[0]]
        for number in numbers.dropFirst() {
            runningTotals = runningTotals.flatMap {
                [
                    $0 + number,
                    $0 * number,
                    applyConcatenation ? "\($0)\(number)".toInt() : nil,
                ]
                .compacted()
                .filter { $0 <= total }
            }

            // If there are no valid options left, stop the loop.
            guard !runningTotals.isEmpty else {
                break
            }
        }

        return runningTotals.contains(total)
    }
}
