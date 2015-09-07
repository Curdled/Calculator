//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Joe Isaacs on 02/09/2015.
//  Copyright (c) 2015 Joe Isaacs. All rights reserved.
//

import Foundation

class CalculatorBrain : Printable{
    
    private enum Op : Printable{
        case Operand(Double)
        case Variable(String)
        case NullaryOperation(String, () -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .Variable(let symbol):
                    return symbol
                case .NullaryOperation(let symbol, _):
                    return symbol
                case .UnaryOperation(let symbol, _):
                     return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
  
    private var opStack = [Op]()
  
    private var knownOps = [String:Op]()

    var variableValues = [String:Double]()

    var description: String {
        return discHelp(description(opStack))
    }

    private func discHelp(input:(String?, [Op])) -> String{
        if let value = input.0{
            let ops =  input.1
            if ops.isEmpty{
              return value
            }
            return discHelp(description(ops)) + ", " + value
        }
        return ""
    }

    private func description(ops: [Op]) -> (result: String?, remainingOps: [Op] ) {
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
                case .Operand(let operand):
                    return ("\(operand)", remainingOps)
                case .Variable(let symbol):
                    return (symbol, remainingOps)
                case .NullaryOperation(let symbol, _):
                    return (symbol, remainingOps)
                case .UnaryOperation(let symbol, _):
                    let opDisc = description(remainingOps)
                    if let value = opDisc.result{
                        return (symbol + "(" + value + ")", opDisc.remainingOps)
                    }
                    else {
                        return (symbol + "(?)", ops)
                    }
                case .BinaryOperation(let symbol, _):
                    let op1Disc = description(remainingOps)
                    if let value1 = op1Disc.result {
                        let op2Disc = description(op1Disc.remainingOps)
                        if let value2 = op2Disc.result{
                            return ("(" + value2 + symbol + value1 + ")", op2Disc.remainingOps)
                        }
                        else {
                            return ("(?" + symbol + value1 + ")", op2Disc.remainingOps)
                        }
                    }
                     else {
                        return ("(?" + symbol + "?)", op1Disc.remainingOps)
                    }
            }
        }
        return (nil, ops)
    }

    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        learnOp(.BinaryOperation("✕", *))
        learnOp(.BinaryOperation("÷", {$1 / $0} ))
        learnOp(.BinaryOperation("+", +))
        learnOp(.BinaryOperation("−", {$1 - $0}))
        learnOp(.UnaryOperation("cos", cos))
        learnOp(.UnaryOperation("sin", cos))
        learnOp(.UnaryOperation("√", sqrt))
        learnOp(.NullaryOperation("π", {M_PI}))
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .Variable(let symbol):
                if let value = variableValues[symbol] {
                    return (value, remainingOps)
                }
                else {
                    return (nil, ops)
                }
            case .NullaryOperation(_, let operation):
                return (operation(), remainingOps)
            case .UnaryOperation(_, let operation):
                let evaluation = evaluate(remainingOps)
                if let value = evaluation.result {
                    return (operation(value), evaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Eval = evaluate(remainingOps)
                if let operand1 = op1Eval.result{
                    let op2Eval = evaluate(op1Eval.remainingOps)
                    if let operand2 = op2Eval.result{
                        return (operation(operand1, operand2), op2Eval.remainingOps)
                    }
                }

            }
        }
        return (nil, ops)
    }
    
    func removeLast(){
        if opStack.count > 0 {
            opStack.removeLast()
        }
    }

    func clear() {
        opStack.removeAll()
        variableValues.removeAll()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) =  evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        println(self)
        return result
    }
  
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }

    func pushOperand(symbol: String) -> Double? {
        opStack.append(.Variable(symbol))
        return evaluate()
    }
  
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}