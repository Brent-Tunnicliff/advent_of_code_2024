// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day11Tests {
    let testData = "125 17"

    @Test
    func testPart1() {
        let challenge = Day11(data: testData)
        #expect(challenge.part1() == 55312)
    }
}
