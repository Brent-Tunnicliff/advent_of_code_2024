// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import Testing

@testable import AdventOfCode

struct Day03Tests {
    let testData = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

    @Test
    func testPart1() {
        let challenge = Day03(data: testData)
        #expect(challenge.part1() == 161)
    }

//    @Test
//    func testPart2() {
//        let challenge = Day03(data: testData)
//        #expect(challenge.part2() == 32000)
//    }
}
