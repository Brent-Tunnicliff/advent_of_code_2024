// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day11: AdventDay {
    let data: String

    var input: [Int] {
        data.split(separator: " ").map { $0.toInt() }
    }

    // Benchmark:
    func part1() -> Int {
        var input = input
        for _ in 0..<25 {
            input = input.blink()
        }

        return input.count
    }
}

extension [Int] {
    fileprivate func blink() -> [Int] {
        reduce(into: [Int]()) { partialResult, element in
            if element == 0 {
                partialResult.append(1)
            } else if element.description.count.isMultiple(of: 2) {
                partialResult.append(contentsOf: element.split)
            } else {
                partialResult.append(element * 2024)
            }
        }
    }
}

extension Int {
    fileprivate var split: [Int] {
        let value = self.description
        let digits = Array(value.chunks(ofCount: value.count / 2))
        precondition(digits.count == 2)
        return [digits[0].toInt(), digits[1].toInt() ]
    }
}
