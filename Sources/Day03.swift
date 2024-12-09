// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper
import Algorithms
import RegexBuilder

struct Day03: AdventDay {
    let data: String

    // Benchmark: 0.014745041 seconds
    func part1() -> Int {
        calculateValues(data)
    }

    // Benchmark: 0.0174155 seconds
    func part2() -> Int {
        // Lets split this into two regex.
        // First one only captures the valid substrings.
        // Then we apply the same capture logic as part one to each match.
        data.matches {
            ChoiceOf {
                Regex {
                    Anchor.startOfSubject
                    Capture(OneOrMore(.any, .reluctant), transform: { $0.toString() })
                    "don't()"
                }
                Regex {
                    "do()"
                    Capture(OneOrMore(.any, .reluctant), transform: { $0.toString() })
                    "don't()"
                }
                Regex {
                    "do()"
                    Capture(OneOrMore(.any, .reluctant), transform: { $0.toString() })
                    Anchor.endOfSubject
                }
            }
        }
        .reduce(into: [String?]()) { partialResult, match in
            partialResult.append(match.output.1)
            partialResult.append(match.output.2)
            partialResult.append(match.output.3)
        }
        .compactMap { $0 }
        .reduce(into: 0) { partialResult, match in
            partialResult += calculateValues(match)
        }
    }

    private func calculateValues(_ input: String) -> Int {
        input.matches {
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
