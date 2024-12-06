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

    func part1() throws -> Int {
        let (grid, startingPosition) = entities
        return try getPositionsVisited(grid: grid, startingPosition: startingPosition).count
    }

    func part2() async throws -> Int {
        let (grid, startingPosition) = entities
        // We only need to check positions the guard would normally visit.
        var possiblePositions = try getPositionsVisited(grid: grid, startingPosition: startingPosition)
        // Cannot replace the starting position.
        possiblePositions.remove(startingPosition)

        return await withTaskGroup(of: Optional<Coordinates>.self) { group in
            for (offset, newObstruction) in possiblePositions.enumerated() {
                group.addTask {
                    let newGrid = grid.adding([newObstruction: .obstruction])
                    do {
                        _ = try getPositionsVisited(
                            grid: newGrid,
                            startingPosition: startingPosition
                        )
                        return nil
                    } catch {
                        guard case .loop = error as? DayError else {
                            preconditionFailure("Unexpected error: \(error)")
                        }

                        return newObstruction
                    }
                }
            }

            var results = 0
            for await result in group where result != nil {
                results += 1
            }

            return results
        }
    }

    private func getPositionsVisited(
        grid: DayGrid,
        startingPosition: Coordinates
    ) throws -> Set<Coordinates> {
        var currentPosition = History(coordinates: startingPosition, direction: .north)
        var history: Set<History> = [currentPosition]
        var inGrid = true
        while inGrid {
            let nextPosition = History(
                coordinates: currentPosition.coordinates.next(in: currentPosition.direction),
                direction: currentPosition.direction
            )

            guard !history.contains(nextPosition) else {
                // Loop!
                throw DayError.loop
            }

            guard let value = grid[nextPosition.coordinates] else {
                // If there is no value then we left the grid
                inGrid = false
                continue
            }

            guard !value.isObstruction else {
                // Turn right and try again
                currentPosition = History(
                    coordinates: currentPosition.coordinates,
                    direction: currentPosition.direction.turnRight
                )
                continue
            }

            // Store the position and move to the next step forward.
            history.insert(nextPosition)
            currentPosition = nextPosition
        }

        return history.map(\.coordinates).toSet()
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

private enum DayError: Error {
    case loop
}

private struct History: Hashable {
    let coordinates: Coordinates
    let direction: CompassDirection
}
