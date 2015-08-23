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
  
  
  var operandStack = Array<Double>()
  
 
  @IBAction func appendDigit(sender: UIButton) {
    let digit = sender.currentTitle!
    if userIsInTheMiddleOfTypingANumber{
      if digit == "." && display.text!.rangeOfString(".") != nil{
        return
      }
      display.text = display.text! + digit
      
    } else {
      if digit != "0" {
        display.text = digit
        userIsInTheMiddleOfTypingANumber = true
      }
    }
  }
  
  @IBAction func enter() {
    operandStack.append(displayValue)
    userIsInTheMiddleOfTypingANumber = false
    println("op stack = \(operandStack)")
  }
  
  @IBAction func operate(sender: UIButton) {
    let operation = sender.currentTitle!
    if(userIsInTheMiddleOfTypingANumber){
      enter()
    }
    switch operation{
      case "✕": performOperation { $0 * $1 }
      case "÷": performOperation { $1 / $0 }
      case "+": performOperation { $0 * $1 }
      case "−": performOperation { $1 - $0 }
      case "√": performOperation { sqrt($0) }
      case "cos": performOperation { cos($0) }
      case "sin": performOperation { sin($0) }
      case "π": performOperation { M_PI }
    default: break
    }
  }
  
  private func performOperation(op: (Double, Double) -> Double){
    if operandStack.count >= 2 {
      displayValue = op(operandStack.removeLast(), operandStack.removeLast())
      enter()
    }
  }

  private func performOperation(op: Double -> Double){
  if operandStack.count >= 1 {
    displayValue = op(operandStack.removeLast())
    enter()
  }
}

  private func performOperation(op: () -> Double){
      displayValue = op()
      enter()
  }
  
  var displayValue: Double{
    get{
      return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
    }
    set {
      display.text = "\(newValue)"
      userIsInTheMiddleOfTypingANumber = false
    }
  }
  
}

