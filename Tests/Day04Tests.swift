// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day04Tests {
    let testData = """
        MMMSXXMASM
        MSAMXMSMSA
        AMXSXMAAMM
        MSAMASMSMX
        XMASAMXAMM
        XXAMMXXAMA
        SMSMSASXSS
        SAXAMASAAA
        MAMMMXMMMM
        MXMXAXMASX
        """

    @Test
    func testPart1() {
        let challenge = Day04(data: testData)
        #expect(challenge.part1() == 18)
    }

    @Test
    func testPart2() {
        let challenge = Day04(data: testData)
        #expect(challenge.part2() == 9)
    }
}
