// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Algorithms

struct Day08: AdventDay {
    let data: String

    private var grid: DayGrid {
        Grid(data: data) {
            switch $0 {
            case ".": .empty
            default: .antenna($0)
            }
        }
    }

    // Benchmark: 0.002104 seconds
    func part1() -> Int {
        let grid = grid
        let antennaTypes = grid.values.compactMap(\.value.antennaLabel).toSet()
        var antinodes: Set<Coordinates> = []
        for antennaType in antennaTypes {
            let antennaLocations = grid.values.compactMap {
                $0.value.antennaLabel == antennaType ? $0.key : nil
            }

            guard antennaLocations.count > 1 else {
                continue
            }

            for pair in antennaLocations.combinations(ofCount: 2) {
                let first = pair[0]
                let second = pair[1]

                antinodes.insert(
                    Coordinates(
                        x: first.x + (first.x - second.x),
                        y: first.y + (first.y - second.y)
                    )
                )

                antinodes.insert(
                    Coordinates(
                        x: second.x + (second.x - first.x),
                        y: second.y + (second.y - first.y)
                    )
                )
            }
        }

        return antinodes.filter { grid[$0] != nil }.count
    }

    // Benchmark: 0.002235334 seconds
    func part2() -> Int {
        // Not much time for this, so lets just copy part 1 and change this time instead of making a reusable functions.
        let grid = grid
        let antennaTypes = grid.values.compactMap(\.value.antennaLabel).toSet()
        var antinodes: Set<Coordinates> = []
        for antennaType in antennaTypes {
            let antennaLocations = grid.values.compactMap {
                $0.value.antennaLabel == antennaType ? $0.key : nil
            }

            guard antennaLocations.count > 1 else {
                continue
            }

            for pair in antennaLocations.combinations(ofCount: 2) {
                let firstAntenna = pair[0]
                let secondAntenna = pair[1]

                antinodes.insert(firstAntenna)
                antinodes.insert(secondAntenna)

                for (firstAntinode, secondAntinode) in [(firstAntenna, secondAntenna), (secondAntenna, firstAntenna)] {
                    var from: Coordinates = firstAntinode
                    var to: Coordinates = secondAntinode
                    while true {
                        let next = next(from: from, to: to)
                        guard grid[next] != nil else {
                            break
                        }

                        antinodes.insert(next)
                        from = to
                        to = next
                    }
                }
            }
        }

        return antinodes.filter { grid[$0] != nil }.count
    }

    private func next(from: Coordinates, to: Coordinates) -> Coordinates {
        Coordinates(
            x: to.x + (to.x - from.x),
            y: to.y + (to.y - from.y)
        )
    }
}

private typealias DayGrid = Grid<Coordinates, GridValue>
private enum GridValue: CustomStringConvertible, Hashable {
    case empty
    case antenna(String)

    var description: String {
        switch self {
        case .empty: return "."
        case let .antenna(label): return label
        }
    }

    var isAntenna: Bool {
        guard case .antenna = self else {
            return false
        }

        return true
    }

    var antennaLabel: String? {
        switch self {
        case .empty: return nil
        case let .antenna(label): return label
        }
    }
}
