// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day04: AdventDay {
    let data: String

    var grid: Grid<Coordinates, String> {
        Grid(data: data)
    }

    func part1() -> Int {
        let word = "XMAS"
        let grid = grid
        let possibleWordStarts = grid.values.filter { $0.value == "X" }
        return possibleWordStarts.reduce(into: 0) { partialResult, item in
            let (key, _) = item
            let possibleWords = [
                [key, key.next(in: .east), key.next(in: .east, distance: 2), key.next(in: .east, distance: 3)],
                [key, key.next(in: .north), key.next(in: .north, distance: 2), key.next(in: .north, distance: 3)],
                [key, key.next(in: .south), key.next(in: .south, distance: 2), key.next(in: .south, distance: 3)],
                [key, key.next(in: .west), key.next(in: .west, distance: 2), key.next(in: .west, distance: 3)],

                // Diagonals
                [
                    key,
                    Coordinates(x: key.x + 1, y: key.y + 1),
                    Coordinates(x: key.x + 2, y: key.y + 2),
                    Coordinates(x: key.x + 3, y: key.y + 3),
                ],
                [
                    key,
                    Coordinates(x: key.x - 1, y: key.y + 1),
                    Coordinates(x: key.x - 2, y: key.y + 2),
                    Coordinates(x: key.x - 3, y: key.y + 3),
                ],
                [
                    key,
                    Coordinates(x: key.x + 1, y: key.y - 1),
                    Coordinates(x: key.x + 2, y: key.y - 2),
                    Coordinates(x: key.x + 3, y: key.y - 3),
                ],
                [
                    key,
                    Coordinates(x: key.x - 1, y: key.y - 1),
                    Coordinates(x: key.x - 2, y: key.y - 2),
                    Coordinates(x: key.x - 3, y: key.y - 3),
                ],
            ]

            partialResult +=
                possibleWords
                .map { $0.map { grid[$0] ?? "" }.joined(separator: "") }
                .filter { $0 == word }
                .count
        }
    }

    func part2() -> Int {
        let word = "MAS"
        let grid = grid
        let possibleWordsJoin = grid.values.filter { $0.value == "A" }
        return possibleWordsJoin.reduce(into: 0) { partialResult, item in
            let (key, _) = item
            let matchingWords = [
                // Diagonals
                [
                    Coordinates(x: key.x - 1, y: key.y - 1),
                    key,
                    Coordinates(x: key.x + 1, y: key.y + 1),
                ],
                [
                    Coordinates(x: key.x + 1, y: key.y - 1),
                    key,
                    Coordinates(x: key.x - 1, y: key.y + 1),
                ],
            ]
            .map {
                $0.map { grid[$0] ?? "" }.joined(separator: "")
            }
            .filter { (value: String) in
                value == word || String(value.reversed()) == word
            }

            if matchingWords.count == 2 {
                partialResult += 1
            }
        }
    }
}
