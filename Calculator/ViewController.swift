//
//  ViewController.swift
//  Calculator
//
//  Created by Joe Isaacs on 23/08/2015.
//  Copyright (c) 2015 Joe Isaacs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!

    var userIsInTheMiddleOfTypingANumber = false

    var brain = CalculatorBrain()


    @IBOutlet weak var historyPanel: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
           if digit == "." && display.text!.rangeOfString(".") != nil{
               //makes sure that multiple dot cannot be inputted.
               return
           }
           historyPanel.text = historyPanel.text! + "\n\(digit)"
           display.text = display.text! + digit

        }
        else {
           if digit != "0" {
               display.text = digit
               historyPanel.text = historyPanel.text! + "\n\(digit)"
               userIsInTheMiddleOfTypingANumber = true
           }
        }
    }

    @IBAction func clear() {
        historyPanel.text = ""
        historyPanel.text = ""

        displayValue = 0
        userIsInTheMiddleOfTypingANumber = false
        brain.clear();
    }

    @IBAction func enter() {
        historyPanel.text = historyPanel.text! + "\n⏎"
        pressEnter()
    }

    func pressEnter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }

    }

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber){
            pressEnter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }

    }


    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
      }

    }

