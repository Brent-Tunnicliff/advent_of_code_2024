// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Algorithms
import RegexBuilder

struct Day03: AdventDay {
    let data: String

    func part1() -> Int {
        data.matches {
            "mul("
            Capture(
                ChoiceOf {
                    One(.digit)
                    Repeat(.digit, count: 2)
                    Repeat(.digit, count: 3)
                },
                transform: { (value: CharacterClass.RegexOutput) in
                    value.toInt()
                }
            )
            ","
            Capture(
                ChoiceOf {
                    One(.digit)
                    Repeat(.digit, count: 2)
                    Repeat(.digit, count: 3)
                },
                transform: { (value: CharacterClass.RegexOutput) in
                    value.toInt()
                }
            )
            ")"
        }
        .reduce(into: 0) { partialResult, match in
            partialResult += match.output.1 * match.output.2
        }
    }
}
