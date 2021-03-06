//
//  CustomGridView.swift
//  Gridy
//
//  Created by Rafal Padberg on 26.12.18.
//  Copyright © 2018 Rafal Padberg. All rights reserved.
//

import UIKit

class CustomGridView: UIView {
    
    // MARK: - Parameters
    
    private var lineWidth: CGFloat = 1
    private var firstLineColor: UIColor = StyleGuide.navy
    private var secondLineColor: UIColor = StyleGuide.yellowLight
    private var gridTilesPerRow: Int = 3 { didSet { setNeedsDisplay() } }
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        contentMode = .redraw
        layer.borderWidth = 1.0
    }
    
    // MARK: - Public API
    
    // Change border color for a blink and change it back to black
    // Change the size of the border so that it covers complete view
    func colorBorder(with color: UIColor) {
        layer.borderColor = color.cgColor
        layer.borderWidth = frame.size.width / 2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    // Change number of tiles but only if is different than current so that it won't be redrawn every time
    func setNumberOf(tiles: Int) {
        if gridTilesPerRow != tiles {
            gridTilesPerRow = tiles
        }
    }
    
    func getNumberOfTiles() -> Int {
        return gridTilesPerRow
    }
    
    // MARK: - Draw
    
    // Draws  2 dashed lines with offsets from left to right and then inverts its points and draws from top to bottom
    // I does that (tilesPerRow - 1) times
    override func draw(_ rect: CGRect) {
        let tileLength = bounds.width / CGFloat(gridTilesPerRow)
        let fullWidth = bounds.width
        
        for i in 1 ..< gridTilesPerRow {
            firstLineColor.setStroke()
            
            let origin = CGPoint(x: bounds.origin.x, y: tileLength * CGFloat(i))
            let targetPoint = CGPoint(x: origin.x + fullWidth, y: origin.y)
            
            var path = calculateLinePath(from: origin, to: targetPoint)
            path.stroke()
            
            path = calculateLinePath(from: invert(point: origin), to: invert(point: targetPoint))
            path.stroke()
            
            secondLineColor.setStroke()
            path = calculateLinePath(from: origin, to: targetPoint, withOffset: 2.0)
            path.stroke()
            
            path = calculateLinePath(from: invert(point: origin), to: invert(point: targetPoint), withOffset: 2.0)
            path.stroke()
        }
    }
    
    // MARK: - Custom Methods
    
    // Returns a linePath from origin to target with set dash offset
    private func calculateLinePath(from origin: CGPoint, to targetPoint: CGPoint, withOffset offset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: origin)
        path.addLine(to: targetPoint)
        path.lineWidth = lineWidth
        path.setLineDash([2,2], count: 2, phase: offset)
        
        return path
    }
    
    private func invert(point: CGPoint) -> CGPoint {
        let newPoint = CGPoint(x: point.y, y: point.x)
        return newPoint
    }
}
