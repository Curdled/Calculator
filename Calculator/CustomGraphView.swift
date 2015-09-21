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
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    struct Constants {
        static let OffsetValue = "CustomGraphView.OffsetValue"
        static let ScaleValue = "CustomGraphView.ScaleValue"
    }
    
    var offset: CGPoint {
        get {
            if let string = defaults.objectForKey(Constants.OffsetValue) as? String {
                return CGPointFromString(string)
            }
            return CGPoint(x: 0, y: 0)
        }
        set {
            defaults.setObject(NSStringFromCGPoint(newValue), forKey: Constants.OffsetValue)
            setNeedsDisplay()
        }
    }

    var middle: CGPoint {
        let point = convertPoint(center, fromView: superview)
        return CGPoint(x: point.x + offset.x, y: point.y + offset.y)
    }
    

    
    @IBInspectable var graphAxisColor: UIColor = UIColor.blueColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var scale: CGFloat {
        get {
            return CGFloat(defaults.floatForKey(Constants.ScaleValue))
        }
        set {
            defaults.setFloat(Float(newValue), forKey: Constants.ScaleValue)
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
    
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation =  gesture.translationInView(self)
            offset = CGPoint(x: offset.x + translation.x, y: offset.y + translation.y)
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            scale *= gesture.scale
            gesture.scale = 1.0
        default: break
        }
    }
    
    func doubleTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            let pos = gesture.locationInView(self)
            let cent = convertPoint(center, fromView: superview)
            offset = CGPoint(x: pos.x - cent.x, y: pos.y - cent.y)
        }
    }
}
