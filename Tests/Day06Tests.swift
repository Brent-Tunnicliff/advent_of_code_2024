// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day06Tests {
    let testData = """
        ....#.....
        .........#
        ..........
        ..#.......
        .......#..
        ..........
        .#..^.....
        ........#.
        #.........
        ......#...
        """

    @Test
    func testPart1() throws {
        let challenge = Day06(data: testData)
        #expect(try challenge.part1() == 41)
    }

    @Test
    func testPart2() async throws {
        let challenge = Day06(data: testData)
        #expect(try await challenge.part2() == 6)
    }
}
