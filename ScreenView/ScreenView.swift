//
//  ScreenView.swift
//  GlitchyDoo
//
//  Created by Алексей Лысенко on 10.02.18.
//  Copyright © 2018 Alexey Lysenko. All rights reserved.
//

import UIKit

@objc protocol ScreenDataSource {
    func screenViewData(_ screenView: ScreenView) -> [[UIColor]]
}

@IBDesignable
class ScreenView: UIView {
    private let dotSize = CGSize(width: 10, height: 10)
    
    private var framesPerSecond: Int = 25
    private var screenLayers: [[CALayer]] = []
    private var updateTimer = Timer()
    
    private(set) var rows: Int!
    private(set) var columns: Int!
    
    var filters: [ScreenFilter] = []
    
    @IBOutlet weak var dataSource: ScreenDataSource? {
        didSet {
            if updateTimer == nil {
                updateTimer = Timer.scheduledTimer(timeInterval: Double(1) / Double(framesPerSecond), target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        rows = Int(frame.height) / Int(dotSize.height)
        columns = Int(frame.width) / Int(dotSize.width)
        
        let widthGap = (frame.width - (dotSize.width * CGFloat(columns))) / 2
        let heightGap = (frame.height -  (dotSize.height * CGFloat(rows))) / 2
        
        screenLayers = []
        (0..<rows).forEach { rowIndex in
            var row: [CALayer] = []
            (0..<columns).forEach { columnIndex in
                let layer = CALayer()
                let origin = CGPoint(
                    x: (CGFloat(columnIndex) * dotSize.width) + widthGap,
                    y: (CGFloat(rowIndex) * dotSize.height) + heightGap
                )
                layer.frame = CGRect(origin: origin, size: dotSize)
                self.layer.addSublayer(layer)
                row.append(layer)
            }
            screenLayers.append(row)
        }
        
        updateTimer = Timer.scheduledTimer(timeInterval: Double(1) / Double(framesPerSecond), target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
    }
    
    @objc private func updateScreen() {
        guard let screenData = dataSource?.screenViewData(self) else {
            updateTimer.invalidate()
            return
        }
        screenLayers.enumerated().forEach { row in
            row.element.enumerated().forEach { column in
                column.element.backgroundColor = screenData[row.offset][column.offset].cgColor
            }
        }
        
        // normalize pixels
        let widthGap = (frame.width - (dotSize.width * CGFloat(columns))) / 2
        let heightGap = (frame.height -  (dotSize.height * CGFloat(rows))) / 2
        (0..<rows).forEach { rowIndex in
            (0..<columns).forEach { columnIndex in
                let layer = screenLayers[rowIndex][columnIndex]
                let origin = CGPoint(
                    x: (CGFloat(columnIndex) * dotSize.width) + widthGap,
                    y: (CGFloat(rowIndex) * dotSize.height) + heightGap
                )
                layer.frame = CGRect(origin: origin, size: dotSize)
            }
        }
        
        filters.forEach { $0.process(layers: screenLayers) }
    }
}


