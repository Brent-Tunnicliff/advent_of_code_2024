// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day13: AdventDay {
    let data: String
    private typealias Entry = (buttonA: Coordinates, buttonB: Coordinates, prize: Coordinates)
    private var entries: [Entry] {
        data.split(separator: "\n\n")
            .reduce(into: [Entry]()) { partialResult, game in
                let rows = game.split(separator: "\n")
                    .map { row in
                        let sections = row.split(separator: ": ")
                        let coordinates = sections[1].split(separator: ", ")
                        let x = coordinates[0].trimmingPrefix("X+").trimmingPrefix("X=").toInt()
                        let y = coordinates[1].trimmingPrefix("Y+").trimmingPrefix("Y=").toInt()
                        return Coordinates(x: x, y: y)
                    }

                partialResult.append(
                    (rows[0], rows[1], rows[2])
                )
            }
    }

    // Benchmark:
    func part1() -> Int {
        let entries = entries
        var cost = 0
        for entry in entries {
            cost += calculateLowestCost(of: entry) ?? 0
        }
        return cost
    }

    private func calculateLowestCost(of entry: Entry) -> Int? {
        var currentOffset = 0
        var result: Int?
        while true {
            currentOffset += 1
            // Not possible, so break.
            guard currentOffset * entry.buttonA.x < entry.prize.x else {
                break
            }

            let xMultiplier = getPotentialMultiplier(
                buttonA: entry.buttonA.x,
                buttonB: entry.buttonB.x,
                result: entry.prize.x,
                offset: currentOffset
            )
            let yMultiplier = getPotentialMultiplier(
                buttonA: entry.buttonA.y,
                buttonB: entry.buttonB.y,
                result: entry.prize.y,
                offset: currentOffset
            )

            guard let xMultiplier, let yMultiplier, xMultiplier == yMultiplier else {
                continue
            }

            let cost = 3 * currentOffset + xMultiplier
            // TODO: validate if this is really working, or even needed.
            if let result, result < cost {
                break
            }

            result = cost
        }

        return result
    }

    private func getPotentialMultiplier(
        buttonA: Int,
        buttonB: Int,
        result: Int,
        offset: Int
    ) -> Int? {
        let buttonAValue = buttonA * offset
        let remaining = result - buttonAValue
        guard remaining % buttonB == 0 else {
            return nil
        }

        return remaining / buttonB
    }
}
