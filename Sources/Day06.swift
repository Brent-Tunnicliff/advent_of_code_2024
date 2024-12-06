// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Algorithms

struct Day06: AdventDay {
    let data: String

    private var entities: (grid: DayGrid, startingPosition: Coordinates) {
        let grid = DayGrid(data: data)
        let startingPositions = grid.values.filter(\.value.isStart).map(\.key)
        precondition(startingPositions.count == 1, "Starting positions: \(startingPositions.count)")
        return (grid, startingPositions[0])
    }

    func part1() -> Int {
        // I am sure this will not work for part 2, haha :)
        let (grid, startingPosition) = entities
        var positionsVisited: Set<Coordinates> = [startingPosition]
        var currentPosition: (coordinates: Coordinates, direction: CompassDirection) = (startingPosition, .north)
        var inGrid = true
        while inGrid {
            let nextPosition = currentPosition.coordinates.next(in: currentPosition.direction)
            guard let value = grid[nextPosition] else {
                // If there is no value then we left the grid
                inGrid = false
                continue
            }

            guard !value.isObstruction else {
                // Turn right and try again
                currentPosition = (currentPosition.coordinates, currentPosition.direction.turnRight)
                continue
            }

            // Store the position and move to the next step forward.
            positionsVisited.insert(nextPosition)
            currentPosition = (nextPosition, currentPosition.direction)
        }

        return positionsVisited.count
    }
}

private typealias DayGrid = Grid<Coordinates, Value>
private enum Value: String, CustomStringConvertible, CaseIterable {
    case empty = "."
    case obstruction = "#"
    case start = "^"

    var description: String { rawValue }

    var isObstruction: Bool {
        self == .obstruction
    }

    var isStart: Bool {
        self == .start
    }
}
