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
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "pan:"))
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "pinch:"))
            let doubleTapRecognizer = UITapGestureRecognizer(target: graphView, action: "doubleTap:")
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
    
}