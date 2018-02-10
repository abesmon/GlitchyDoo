//
//  Utils.swift
//  GlitchyDoo
//
//  Created by Алексей Лысенко on 10.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import Foundation

func slideDown<Element>(column: Int, of array: [[Element]]) -> [[Element]] {
    guard array.first!.count > column else { return array }
    var columnArr = array.flatMap { row in return row[column] }
    columnArr.insert(columnArr.popLast()!, at: 0)
    let moded: [[Element]] = array.enumerated().flatMap { row in
        var modedRow = row.element
        modedRow[column] = columnArr[row.offset]
        return modedRow
    }
    return moded
}
