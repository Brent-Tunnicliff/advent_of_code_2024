// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day11Tests {
    let testData = "125 17"

    @Test
    func testPart1() async {
        let challenge = Day11(data: testData)
        let result = await challenge.part1()
        #expect(result == 55312)
    }

    @Test
    func testPart2() async {
        let challenge = Day11(data: testData)
        let result = await challenge.part2()
        #expect(result == 65_601_038_650_482)
    }
}
