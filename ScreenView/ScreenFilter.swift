//
//  ScreenFilter.swift
//  GlitchyDoo
//
//  Created by Алексей Лысенко on 10.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import Foundation
import UIKit

class ScreenFilter {
    func process(layers: [[CALayer]]) {}
}

class RandomColorFilter: ScreenFilter {
    override func process(layers: [[CALayer]]) {
        layers.forEach { row in
            row.forEach { columnItem in
                columnItem.backgroundColor = Bool.random() ? UIColor.random().cgColor : columnItem.backgroundColor
            }
        }
    }
}

class PositionNoiceFilter: ScreenFilter {
    override func process(layers: [[CALayer]]) {
        layers.forEach { row in
            row.forEach { columnItem in
                if Bool.random() {
                    let position = CGPoint(
                        x: columnItem.position.x + CGFloat.random(min: -0.2, max: 0.2),
                        y: columnItem.position.y + CGFloat.random(min: -0.2, max: 0.2)
                    )
                    columnItem.frame = CGRect(origin: position, size: columnItem.frame.size)
                }
            }
        }
    }
}
