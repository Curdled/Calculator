//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Joe Isaacs on 02/09/2015.
//  Copyright (c) 2015 Joe Isaacs. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op : Printable{
        case Operand(Double)
        case NullaryOperation(String, () -> Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                        return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .NullaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
  
    private var opStack = [Op]()
  
    private var knownOps = [String:Op]()
    

    
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

    func clear() {
        opStack.removeAll()
    }
    
    func evaluate() -> Double? {
        let (result, remainder) =  evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
  
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
  
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
}