//
//  CustomGraphView.swift
//  Calculator
//
//  Created by Joe Isaacs on 19/09/2015.
//  Copyright (c) 2015 Joe Isaacs. All rights reserved.
//

import UIKit

protocol xyGraphDataSource : class {
    func yValueAt(x: CGFloat) -> CGFloat?
}


@IBDesignable
class CustomGraphView : UIView {
    
    var delegate: xyGraphDataSource?

    var middle: CGPoint {
        let point = convertPoint(center, fromView: superview)
        return CGPoint(x: point.x + offset.x, y: point.y + offset.y)
    }
    
    @IBInspectable var scale = CGFloat(1.0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var offset = CGPoint(x: 0, y: 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    

    
    @IBInspectable var graphAxisColor: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
        
    var graphCenter: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    
    var graphRect: CGRect {
        return convertRect(frame, fromView: superview)
    }
    
    override func drawRect(dirtyRect: CGRect) {
        println("render")
        let axisDrawer = AxesDrawer(color: graphAxisColor)
        
        let offsetValue = offset
        let scaleValue = scale
        let middleValue = middle

        axisDrawer.drawAxesInRect(graphRect, origin: middle,
            pointsPerUnit: scaleValue)
        let width = graphRect.width
        let frame = graphRect
        var path = UIBezierPath()
        for index in 0...Int(width) {
            // index to x coordinates
            let xPos = (CGFloat(index) - (width / 2.0) - offsetValue.x) / scaleValue
            if let yValue = delegate?.yValueAt(xPos) {
                // y coordinates to pixel value
                let yPos = middleValue.y - yValue * scaleValue
                let point = CGPoint(x: CGFloat(index), y: yPos)
                if path.empty {
                    path.moveToPoint(point)
                } else {
                    path.addLineToPoint(point)
                }
            } else {
                path.stroke()
                path.removeAllPoints()
            }
            if !path.empty {
                path.stroke()
            }
        }
    }
    
    func convertPointToCoord(point: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
    
    func convertCoordToPoint(point: CGPoint) -> CGPoint {
        return CGPoint(x: 0, y: 0)
    }
}
