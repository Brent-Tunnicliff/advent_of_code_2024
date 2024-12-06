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
    func testPart1() {
        let challenge = Day06(data: testData)
        #expect(challenge.part1() == 41)
    }
}
