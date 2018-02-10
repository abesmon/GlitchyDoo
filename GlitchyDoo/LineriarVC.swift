//
//  LineriarVC.swift
//  GlitchyDoo
//
//  Created by Алексей Лысенко on 10.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import UIKit

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

class LineriarVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private var initialized: Bool = false
    private var screenData = [[UIColor]]()
    
    private func initializeData(for screenView: ScreenView) {
        let randomRows: [UIColor] = (0..<screenView.rows).flatMap { row in
            return Bool.random() ? .black : .white
        }
        screenData = (0..<screenView.rows).flatMap { row in
            return (0..<screenView.columns).flatMap { column in
                return randomRows[row]
            }
        }
        initialized = true
    }
    
    private var updateCount: Int = 0
    private func updateData() {
        let wait: Int = 5
        let width = screenData.first!.count
        let height = screenData.count
        let cycleLength = height + width + wait
        
        let currentCycleStep = updateCount % cycleLength
        
        var minColumn = max(currentCycleStep - height, 0)
        var maxColumn = currentCycleStep
        (minColumn..<maxColumn).forEach { column in
            screenData = slideDown(column: column, of: screenData)
        }
        
        updateCount += 1
    }
    // one lapse is height <- for movement + width idle + n of wait
    
}

extension LineriarVC: ScreenDataSource {
    func screenViewData(_ screenView: ScreenView) -> [[UIColor]] {
        if !initialized {
            initializeData(for: screenView)
        } else {
            updateData()
        }
        return screenData
    }
}
