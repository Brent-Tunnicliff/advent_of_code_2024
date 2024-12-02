// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day02: AdventDay {
    let data: String

    private var reports: [[Int]] {
        data.split(separator: "\n")
            .map { report in
                report.split(separator: " ")
                    .map {
                        $0.toInt()
                    }
            }
    }

    func part1() -> Int {
        reports.filter {
            $0.isSafe()
        }.count
    }
}

extension [Int] {
    fileprivate func isSafe() -> Bool {
        var previous = self[0]
        let isIncrementing = previous < self[1]
        let valueRange = 1...3
        for value in self.dropFirst() {
            let difference = isIncrementing ? value - previous : previous - value
            guard valueRange.contains(difference) else {
                return false
            }

            // Keep looping
            previous = value
        }

        return true
    }
}
