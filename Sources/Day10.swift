// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day10: AdventDay {
    let data: String

    // Ha! I misread part 1 and my first attempt to implement ended up being the actual part 2 answer.
    // Benchmark: 0.01364775 seconds
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
                    ).endPositions
                )
            }

            trailheadCount += results.count
        }

        return trailheadCount
    }

    // Benchmark: 0.000938416 seconds
    func part2() async -> Int {
        let grid = DayGrid(data: data)
        let startingPositions = grid.values.filter { $0.value == 0 }.keys
        var ratingCount = 0
        for position in startingPositions {
            for direction in CompassDirection.allCases {
                ratingCount += await getTrailheadEndPositions(
                    grid: grid,
                    currentPosition: position,
                    nextDirection: direction
                ).rating
            }
        }

        return ratingCount
    }

    private let cache = Cache<Heading, Result>()
    private func getTrailheadEndPositions(
        grid: DayGrid,
        currentPosition: Coordinates,
        nextDirection: CompassDirection
    ) async -> Result {
        let result: Result
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
            result = Result(endPositions: [], rating: 0)
            await cache.set(result, for: heading)
            return result
        }

        guard nextValue != 9 else {
            result = Result(endPositions: [nextPosition], rating: 1)
            await cache.set(result, for: heading)
            return result
        }

        var partialResult: [Result] = []
        for direction in CompassDirection.allCases {
            partialResult.append(
                await getTrailheadEndPositions(
                    grid: grid,
                    currentPosition: nextPosition,
                    nextDirection: direction
                )
            )
        }

        result = partialResult.merged()
        await cache.set(result, for: heading)
        return result
    }
}

private typealias DayGrid = Grid<Coordinates, Int>
private struct Heading: Hashable {
    let coordinates: Coordinates
    let direction: CompassDirection
}

private struct Result {
    let endPositions: Set<Coordinates>
    let rating: Int
}

extension [Result] {
    fileprivate func merged() -> Result {
        Result(
            endPositions: Set(flatMap(\.endPositions)),
            rating: reduce(into: 0) { partialResult, element in
                partialResult += element.rating
            }
        )
    }
}
