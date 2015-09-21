//
//  GraphViewController.swift
//  Calculator
//
//  Created by Joe Isaacs on 19/09/2015.
//  Copyright (c) 2015 Joe Isaacs. All rights reserved.
//

import UIKit


class GraphViewController : UIViewController, xyGraphDataSource {
    
    @IBOutlet weak var graphView: CustomGraphView! {
        didSet {
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "pan:"))
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "pinch:"))
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "doubleTap:")
            doubleTapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapRecognizer)
            graphView.delegate = self
        }
    }
    
    @IBOutlet weak var graphTitleLabel: UINavigationItem! {
        didSet {
            if let title = graphTitle {
                println(title)
                graphTitleLabel.title = title
            }
        }
    }
    
    @IBInspectable var graphTitle: String?
    
    var brainCopy: CalculatorBrain?

    
    func yValueAt(x: CGFloat) -> CGFloat? {
        if let brain = brainCopy {
            brain.variableValues["M"] = Double(x)
            if let value = brain.evaluate() {
                if value.isNormal {
                    return CGFloat(value)
                }
            }
        }
        return nil
    }
    
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
            graphView.offset = newValue
        }
    }
    
    @IBInspectable var scale: CGFloat {
        get {
            return CGFloat(defaults.floatForKey(Constants.ScaleValue))
        }
        set {
            defaults.setFloat(Float(newValue), forKey: Constants.ScaleValue)
            graphView.scale = newValue
        }
    }
    
    
    func pan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation =  gesture.translationInView(graphView)
            offset = CGPoint(x: offset.x + translation.x, y: offset.y + translation.y)
            gesture.setTranslation(CGPointZero, inView: graphView)
        default: break
        }
    }
    
    func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .Changed:
            graphView.scale *= gesture.scale
            gesture.scale = 1.0
        default: break
        }
    }
    
    func doubleTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            let pos = gesture.locationInView(graphView)
            let cent = graphView.graphCenter
            offset = CGPoint(x: pos.x - cent.x, y: pos.y - cent.y)
        }
    }
    
}