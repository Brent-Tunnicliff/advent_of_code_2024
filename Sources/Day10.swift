// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day10: AdventDay {
    let data: String

    // Benchmark:
    func part1() async -> Int {
        let grid = DayGrid(data: data)
        let startingPositions = grid.values.filter { $0.value == 0 }.keys
        var trailheadCount = 0
        for position in startingPositions {
            var results: Set<Coordinates> = []
            for direction in CompassDirection.allCases {
                results.formUnion(
                    await getTrailheadEndPositions(
                        grid: grid,
                        currentPosition: position,
                        nextDirection: direction
                    )
                )
            }

            trailheadCount += results.count
        }

        return trailheadCount
    }

    private let cache = Cache<Heading, Set<Coordinates>>()
    private func getTrailheadEndPositions(
        grid: DayGrid,
        currentPosition: Coordinates,
        nextDirection: CompassDirection
    ) async -> Set<Coordinates> {
        let result: Set<Coordinates>
        let heading = Heading(coordinates: currentPosition, direction: nextDirection)
        if let cachedCount = await cache.object(for: heading) {
            return cachedCount
        }

        let nextPosition = currentPosition.next(in: nextDirection)
        guard
            let currentValue = grid[currentPosition],
            let nextValue = grid[nextPosition],
            currentValue + 1 == nextValue
        else {
            result = []
            await cache.set(result, for: heading)
            return result
        }

        guard nextValue != 9 else {
            result = [nextPosition]
            await cache.set(result, for: heading)
            return result
        }

        var partialResult: Set<Coordinates> = []
        for direction in CompassDirection.allCases {
            partialResult.formUnion(
                await getTrailheadEndPositions(
                    grid: grid,
                    currentPosition: nextPosition,
                    nextDirection: direction
                )
            )
        }

        result = partialResult
        await cache.set(result, for: heading)
        return result
    }
}

private typealias DayGrid = Grid<Coordinates, Int>
private struct Heading: Hashable {
    let coordinates: Coordinates
    let direction: CompassDirection
}
