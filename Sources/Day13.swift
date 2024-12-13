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

    // Benchmark: 0.013329292 seconds
    func part1() -> Int {
        let entries = entries
        var cost = 0
        for entry in entries {
            cost += calculateLowestCost(of: entry) ?? 0
        }
        return cost
    }

    // Benchmark: 0.011928333 seconds
    func part2() -> Int {
        let entries = entries.map {
            (
                $0.buttonA,
                $0.buttonB,
                Coordinates(
                    x: $0.prize.x + 10_000_000_000_000,
                    y: $0.prize.y + 10_000_000_000_000
                )
            )
        }
        var cost = 0
        for entry in entries {
            cost += calculateLowestCost(of: entry) ?? 0
        }

        return cost
    }

    // I needed to look up the equation for this online.
    // Looks like we are getting to the point were knowledge of mathematical equations gets more important.
    private func calculateLowestCost(of entry: Entry) -> Int? {
        let pX = entry.prize.x
        let pY = entry.prize.y
        let aX = entry.buttonA.x
        let aY = entry.buttonA.y
        let bX = entry.buttonB.x
        let bY = entry.buttonB.y

        let bCount = (aY * pX - aX * pY) / (aY * bX - aX * bY)
        let bCountRemainder = (aY * pX - aX * pY) % (aY * bX - aX * bY)
        guard bCount >= 0, bCountRemainder == 0 else {
            return nil
        }

        let aCount = (pY - bY * bCount) / aY
        let aCountRemainder = (pY - bY * bCount) % aY
        guard aCount >= 0, aCountRemainder == 0 else {
            return nil
        }

        return 3 * aCount + bCount
    }
}
