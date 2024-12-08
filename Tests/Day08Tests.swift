// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day08Tests {
    let testData = """
        ............
        ........0...
        .....0......
        .......0....
        ....0.......
        ......A.....
        ............
        ............
        ........A...
        .........A..
        ............
        ............
        """

    @Test
    func testPart1() {
        let challenge = Day08(data: testData)
        #expect(challenge.part1() == 14)
    }

    @Test
    func testPart2() {
        let challenge = Day08(data: testData)
        #expect(challenge.part2() == 34)
    }
}
