//
//  Collection+Helpers.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 01/12/2021.
//  Copyright © 2021 Thomas Durand. All rights reserved.
//

import Foundation

extension Collection {
    func count(where condition: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in self {
            count += try condition(element) ? 1 : 0
        }
        return count
    }
}
