// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day09Tests {
    let testData = """
        2333133121414131402
        """

    @Test
    func testPart1() {
        let challenge = Day09(data: testData)
        #expect(challenge.part1() == 1928)
    }

    @Test
    func testPart2() {
        let challenge = Day09(data: testData)
        #expect(challenge.part2() == 2858)
    }
}
