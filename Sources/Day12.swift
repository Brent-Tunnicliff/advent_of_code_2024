// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day12: AdventDay {
    let data: String

    // Benchmark:
    func part1() -> Int {
        let grid = DayGrid(data: data)
        let regions = getRegions(from: grid)
        var cost = 0
        for region in regions {
            let area = region.count
            let perimeter = calculatePerimeter(of: region)
            cost += area * perimeter
        }

        return cost
    }

    private func getRegions(from grid: DayGrid) -> [[Coordinates]] {
        guard let firstValue = grid.values.first else {
            return []
        }

        var region: [Coordinates] = [firstValue.key]
        var queue = [firstValue.key]
        while !queue.isEmpty {
            let nextKey = queue.removeFirst()
            for direction in CompassDirection.allCases {
                guard
                    let nextKey = grid.getCoordinates(from: nextKey, direction: direction),
                    // Only capture it if it is the same value.
                    grid[nextKey] == firstValue.value,
                    !region.contains(nextKey)
                else {
                    continue
                }

                region.append(nextKey)
                queue.append(nextKey)
            }
        }

        return [region] + getRegions(from: grid.removing(keys: region))
    }

    private func calculatePerimeter(of region: [Coordinates]) -> Int {
        var perimeter = 0
        for value in region {
            let neighbours = CompassDirection.allCases
                .map { value.next(in: $0) }
                .filter { region.contains($0) }

            precondition(neighbours.count <= 4)
            perimeter += 4 - neighbours.count
        }

        return perimeter

    }
}

private typealias DayGrid = Grid<Coordinates, String>
