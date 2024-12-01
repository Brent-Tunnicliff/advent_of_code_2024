// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day01Tests {
    // Smoke test data provided in the challenge question
    let testData = """
        3   4
        4   3
        2   5
        1   3
        3   9
        3   3
        """

    @Test
    func testPart1() {
        let challenge = Day01(data: testData)
        #expect(challenge.part1() == 11)
    }

    @Test
    func testPart2() {
        let challenge = Day01(data: testData)
        #expect(challenge.part2() == 31)
    }
}
