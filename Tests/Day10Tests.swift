// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day10Tests {
    let testData = """
        89010123
        78121874
        87430965
        96549874
        45678903
        32019012
        01329801
        10456732
        """

    @Test
    func testPart1() async {
        let challenge = Day10(data: testData)
        let result = await challenge.part1()
        #expect(result == 36)
    }

    @Test
    func testPart2() async {
        let challenge = Day10(data: testData)
        let result = await challenge.part2()
        #expect(result == 81)
    }
}
