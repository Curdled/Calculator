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

    @IBOutlet weak var discriptionPanel: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    var brain = CalculatorBrain()

 
    @IBAction func setMemory() {
        if let value =  displayValue {
            brain.variableValues["M"] = value
        }
        userIsInTheMiddleOfTypingANumber = false
        displayValue = brain.evaluate()
        display.text = "=" + display.text!
    }

    @IBAction func pushMemory() {
        brain.pushOperand("M")
        enter()
    }
    
    @IBAction func undo() {
        if userIsInTheMiddleOfTypingANumber {
            let displayText = display.text!
            if count(displayText) == 1 {
                display.text! = " "
                userIsInTheMiddleOfTypingANumber = false
            }
            else if(count(displayText) > 1) {
                display.text! = dropLast(displayText)
            }
        }
        else {
            brain.removeLast()
            enter()
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber{
           if digit == "." && display.text!.rangeOfString(".") != nil{
               //makes sure that multiple dot cannot be inputted.
               return
           }
           display.text = display.text! + digit
        }
        else {
           if digit != "0" {
               display.text = digit
               userIsInTheMiddleOfTypingANumber = true
           }
        }
    }

    @IBAction func clear() {
        discriptionPanel.text = " "
        displayValue = nil
        userIsInTheMiddleOfTypingANumber = false
        brain.clear();
    }

    @IBAction func enter() {
        if userIsInTheMiddleOfTypingANumber {
            userIsInTheMiddleOfTypingANumber = false
            if let displayValueInt = displayValue {
                displayValue = brain.pushOperand(displayValueInt)
            }
        } else {
            displayValue = brain.evaluate()
        }
        display.text = "=" + display.text!
        discriptionPanel.text = "\(brain)"
    }

    

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if(userIsInTheMiddleOfTypingANumber){
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                display.text = "=" + display.text!
            } else {
                displayValue = nil
            }
        }
        discriptionPanel.text = "\(brain)"
    }


    var displayValue: Double? {
        get {
            if let number =  NSNumberFormatter().numberFromString(display.text!){
                return number.doubleValue
            }
            return nil
        }
        set {
            if let value = newValue {
              display.text = "\(value)"
            }
            else {
                display.text = "nil"
            }
            userIsInTheMiddleOfTypingANumber = false
        }
      }
    }