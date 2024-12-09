// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day02: AdventDay {
    let data: String

    private let acceptedValueRange = 1...3
    private var reports: [[Int]] {
        data.split(separator: "\n")
            .map { report in
                report.split(separator: " ")
                    .map {
                        $0.toInt()
                    }
            }
    }

    // Benchmark: 0.00676025 seconds
    func part1() -> Int {
        reports.filter {
            isSafe(report: $0, previousLevels: [], tolerance: 0, isIncrementing: nil)
        }.count
    }

    // Benchmark: 0.006877542 seconds
    func part2() -> Int {
        reports.filter {
            isSafe(report: $0, previousLevels: [], tolerance: 1, isIncrementing: nil)
        }.count
    }

    private func isSafe(report: [Int], previousLevels: [Int], tolerance: Int, isIncrementing: Bool?) -> Bool {
        guard !previousLevels.isEmpty else {
            return isSafe(
                report: Array(report.dropFirst()),
                previousLevels: [report[0]],
                tolerance: tolerance,
                isIncrementing: isIncrementing
            )
        }

        // At the end, so must be safe.
        guard report.count > 0 else {
            return true
        }

        let level = report[0]
        let previousLevel = previousLevels.last ?? -1
        let isIncrementing = isIncrementing ?? (previousLevel < level)
        let difference = isIncrementing ? level - previousLevel : previousLevel - level
        let remainingReport = Array(report.dropFirst())
        guard !acceptedValueRange.contains(difference) else {
            return isSafe(
                report: remainingReport,
                previousLevels: previousLevels + [level],
                tolerance: tolerance,
                isIncrementing: isIncrementing
            )
        }

        guard tolerance > 0 else {
            return false
        }

        // If it is not safe either the current or previous value can be dropped, so lets try both.
        let droppingPreviousIsSafe = isSafe(
            report: remainingReport.dropLast() + [level],
            previousLevels: previousLevels.dropLast(),
            tolerance: tolerance - 1,
            isIncrementing: isIncrementing
        )

        let droppingCurrentIsSafe = isSafe(
            report: [previousLevel] + remainingReport,
            previousLevels: previousLevels.dropLast(),
            tolerance: tolerance - 1,
            isIncrementing: isIncrementing
        )

        return droppingPreviousIsSafe || droppingCurrentIsSafe
    }
}
