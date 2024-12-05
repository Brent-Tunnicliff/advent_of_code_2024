// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day05Tests {
    let testData = """
        47|53
        97|13
        97|61
        97|47
        75|29
        61|13
        75|53
        29|13
        97|29
        53|29
        61|53
        97|53
        61|29
        47|13
        75|47
        97|75
        47|61
        75|61
        47|29
        75|13
        53|13

        75,47,61,53,29
        97,61,53,29,13
        75,29,13
        75,97,47,61,53
        61,13,29
        97,13,75,29,47
        """

    @Test
    func testPart1() {
        let challenge = Day05(data: testData)
        #expect(challenge.part1() == 143)
    }

    @Test
    func testPart2() {
        let challenge = Day05(data: testData)
        #expect(challenge.part2() == 123)
    }
}
