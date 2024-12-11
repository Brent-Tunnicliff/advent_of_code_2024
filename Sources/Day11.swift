// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day11: AdventDay {
    let data: String

    var input: [Int] {
        data.split(separator: " ").map { $0.toInt() }
    }

    // Benchmark: 0.005274542 seconds
    func part1() async -> Int {
        var result = 0
        for number in input {
            result += await calculateBlinks(value: number, remainingBlinks: 25)
        }

        return result
    }

    // Benchmark: 0.156297333 seconds
    func part2() async -> Int {
        var result = 0
        for number in input {
            result += await calculateBlinks(value: number, remainingBlinks: 75)
        }

        return result
    }

    private func calculateBlinks(value: Int, remainingBlinks: Int) async -> Int {
        let cacheKey = Key(value: value, remainingBlinks: remainingBlinks)
        if let cachedValue = await cache.object(for: cacheKey) {
            return cachedValue
        }

        let newRemainingBlinks = remainingBlinks - 1
        guard newRemainingBlinks >= 0 else {
            return 1
        }

        let newValues: [Int] =
            if value == 0 {
                [1]
            } else if value.description.count.isMultiple(of: 2) {
                value.split
            } else {
                [value * 2024]
            }

        var results = 0
        for newValue in newValues {
            results += await calculateBlinks(value: newValue, remainingBlinks: newRemainingBlinks)
        }

        await cache.set(results, for: cacheKey)
        return results
    }
}

private let cache = Cache<Key, Int>()
private struct Key: Hashable {
    let value: Int
    let remainingBlinks: Int
}

extension Int {
    fileprivate var split: [Int] {
        let value = self.description
        let digits = Array(value.chunks(ofCount: value.count / 2))
        precondition(digits.count == 2)
        return [digits[0].toInt(), digits[1].toInt()]
    }
}
