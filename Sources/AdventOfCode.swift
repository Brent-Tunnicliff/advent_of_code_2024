import ArgumentParser

// Add each new day implementation to this array:
let allChallenges: [any AdventDay] = [
    Day00(),
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08(),
    Day09(),
    Day10(),
    Day11(),
    Day12(),
]

@main
struct AdventOfCode: AsyncParsableCommand {
    @Argument(help: "The day of the challenge. For December 1st, use '1'.")
    var day: Int?

    @Flag(help: "Run all the days available")
    var all: Bool = false

    /// The selected day, or the latest day if no selection is provided.
    var selectedChallenge: any AdventDay {
        get throws {
            guard let day else {
                return latestChallenge
            }

            guard let challenge = allChallenges.first(where: { $0.day == day }) else {
                throw ValidationError("No solution found for day \(day)")
            }

            return challenge
        }
    }

    /// The latest challenge in `allChallenges`.
    var latestChallenge: any AdventDay {
        guard let latestChallenge = allChallenges.max(by: { $0.day < $1.day }) else {
            fatalError("No day found")
        }

        return latestChallenge
    }

    func run<T>(part: () async throws -> T, named: String) async -> Duration {
        var result: Result<T, Error>?
        let timing = await ContinuousClock().measure {
            do {
                result = .success(try await part())
            } catch {
                result = .failure(error)
            }
        }

        switch result {
        case .success(let success):
            print("\(named): \(success)")
        case .failure(let failure as PartUnimplemented):
            print("Day \(failure.day) part \(failure.part) unimplemented")
        case .failure(let failure):
            print("\(named): Failed with error: \(failure)")
        case nil:
            fatalError("Nil result")
        }

        return timing
    }

    func run() async throws {
        let challenges = all ? allChallenges : try [selectedChallenge]

        for challenge in challenges {
            print("Executing Advent of Code challenge \(challenge.day)...")

            let timing1 = await run(part: challenge.part1, named: "Part 1")
            let timing2 = await run(part: challenge.part2, named: "Part 2")

            print("Part 1 took \(timing1), part 2 took \(timing2).")
            #if DEBUG
                print("Looks like you're benchmarking debug code. Try swift run -c release")
            #endif
        }
    }
}
