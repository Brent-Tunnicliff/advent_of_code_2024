// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day09: AdventDay {
    let data: String

    private let empty: String = "."
    private var entities: [Int: String] {
        data.trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "")
            .chunks(ofCount: 2)
            .enumerated()
            .reduce(into: [Int: String]()) { partialResult, value in
                var currentIndex = partialResult.count
                let (offset, pair) = value
                let fileLength = pair.first?.toInt() ?? 0
                for _ in 0..<fileLength {
                    partialResult[currentIndex] = offset.description
                    currentIndex += 1
                }

                // If there is only one item in the pair,
                // we are probably at the final item and there is no empty defined.
                guard pair.count > 1 else {
                    return
                }

                let emptyLength = pair.last?.toInt() ?? 0
                for _ in 0..<emptyLength {
                    partialResult[currentIndex] = empty
                    currentIndex += 1
                }
            }
    }

    // Benchmark: 15.101083416 seconds
    func part1() -> Int {
        let entities = entities
        var files = entities.filter { $0.value != empty }
        var emptyPositions = entities.filter({ $0.value == empty })

        let lastFile = files.values.compactMap { Int($0) }.max()
        guard let lastFile else {
            preconditionFailure("Unable to find last file number")
        }

        var currentFileNumber = lastFile
        outerLoop: while currentFileNumber >= 0 {
            let filePositions: [Int] = files.filter({ $0.value == currentFileNumber.description }).keys.sorted(by: >)
            precondition(!filePositions.isEmpty, "Unable to find file positions")

            for filePosition in filePositions {
                guard
                    let emptyPosition = emptyPositions.keys.min(),
                    emptyPosition < filePosition
                else {
                    // No more empty positions, so end the loop.
                    break outerLoop
                }

                emptyPositions[emptyPosition] = nil
                files[emptyPosition] = currentFileNumber.description

                emptyPositions[filePosition] = empty
                files[filePosition] = nil
            }

            currentFileNumber -= 1
        }

        return getAnswer(files: files)
    }

    // Short on time so copy, paste, and edit from part 1 again.
    // Benchmark: 29.713594833000002 seconds
    func part2() -> Int {
        let entities = entities
        var files = entities.filter { $0.value != empty }
        var allEmptyPositions = entities.filter { $0.value == empty }
            .keys
            .sorted()
            .reduce(into: [ClosedRange<Int>]()) { partialResult, value in
                guard let last = partialResult.last, last.upperBound + 1 == value else {
                    partialResult.append(value...value)
                    return
                }

                partialResult[partialResult.count - 1] = last.lowerBound...value
            }
            .toSet()

        let lastFile = files.values.compactMap { Int($0) }.max()
        guard let lastFile else {
            preconditionFailure("Unable to find last file number")
        }

        var currentFileNumber = lastFile
        while currentFileNumber >= 0 {
            let filePositions: [Int] = files.filter({ $0.value == currentFileNumber.description }).keys.sorted()
            precondition(!filePositions.isEmpty, "Unable to find file positions")

            let potentialEmptyPositions = allEmptyPositions.filter {
                $0.count >= filePositions.count && $0.lowerBound < filePositions[0]
            }

            guard let emptyPosition = potentialEmptyPositions.min(by: { $0.lowerBound < $1.lowerBound }) else {
                currentFileNumber -= 1
                continue
            }

            allEmptyPositions.remove(emptyPosition)
            let emptyPositionsToFill: ClosedRange<Int>
            if emptyPosition.count == filePositions.count {
                emptyPositionsToFill = emptyPosition
            } else {
                let newUpperBound = emptyPosition.lowerBound + filePositions.count - 1
                emptyPositionsToFill = emptyPosition.lowerBound...newUpperBound
                allEmptyPositions.insert((newUpperBound + 1)...emptyPosition.upperBound)
            }

            for filePosition in filePositions {
                files[filePosition] = nil
            }

            for emptyPosition in emptyPositionsToFill {
                files[emptyPosition] = currentFileNumber.description
            }

            currentFileNumber -= 1
        }

        return getAnswer(files: files)
    }

    private func getAnswer(files: [Int: String]) -> Int {
        files.keys.reduce(into: 0) { partialResult, key in
            guard let value = files[key], value != empty else {
                return
            }

            partialResult += key * value.toInt()
        }
    }
}
