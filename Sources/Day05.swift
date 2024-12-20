// Copyright © 2024 Brent Tunnicliff <brent@tunnicliff.dev>

import AOCHelper

struct Day05: AdventDay {
    let data: String

    /// orderingRules: Key is page number, values are other page numbers that must be printed after it.
    private typealias Pages = (orderingRules: [Int: Set<Int>], pagesToProduce: [[Int]])
    private var pages: Pages {
        let sections = data.split(separator: "\n\n")
        precondition(sections.count == 2)
        let orderingRules = sections[0]
            .split(separator: "\n")
            .reduce(into: [Int: Set<Int>]()) { partialResult, row in
                let numbers = row.split(separator: "|").map { $0.toInt() }
                precondition(numbers.count == 2)
                let first = numbers[0]
                let second = numbers[1]
                var values: Set<Int> = partialResult[first] ?? []
                values.insert(second)
                partialResult[first] = values
            }
        let pagesToProduce = sections[1]
            .split(separator: "\n")
            .reduce(into: [[Int]]()) { partialResult, row in
                partialResult.append(
                    row.split(separator: ",").map { $0.toInt() }
                )
            }
        return (orderingRules, pagesToProduce)
    }

    // Benchmark: 0.008488458 seconds
    func part1() -> Int {
        let (orderingRules, pagesToProduce) = pages
        return pagesToProduce.reduce(into: 0) { partialResult, pageUpdate in
            for (index, page) in pageUpdate.enumerated() {
                let rulesForPage = orderingRules[page] ?? []
                let previousPages = Set(pageUpdate.dropLast(pageUpdate.count - index))
                // If any rules are broken, move to next pageUpdate.
                guard previousPages.intersection(rulesForPage).isEmpty else {
                    return
                }

                // Otherwise, continue for loop to next index.
            }

            // if we have reached here, it means the pageUpdate is valid.
            let indexToAdd = pageUpdate.count / 2
            partialResult += pageUpdate[indexToAdd]
        }
    }

    // Benchmark: 0.007834917 seconds
    func part2() -> Int {
        let (orderingRules, pagesToProduce) = pages
        return pagesToProduce.reduce(into: 0) { partialResult, pageUpdate in
            var isValid = true
            for (index, page) in pageUpdate.enumerated() {
                let rulesForPage = orderingRules[page] ?? []
                let previousPages = Set(pageUpdate.dropLast(pageUpdate.count - index))
                guard previousPages.intersection(rulesForPage).isEmpty else {
                    isValid = false
                    break
                }

                // Otherwise, continue for loop to next index.
            }

            // If no rules are broken, move to next pageUpdate.
            guard !isValid else {
                return
            }

            let sortedPageUpdate = pageUpdate.sorted { lhs, rhs in
                orderingRules[lhs]?.contains(rhs) ?? false
            }

            // if we have reached here, it means the pageUpdate is valid.
            let indexToAdd = sortedPageUpdate.count / 2
            partialResult += sortedPageUpdate[indexToAdd]
        }
    }
}
