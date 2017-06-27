//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chance ONeal on 6/25/17.
//  Copyright © 2017 Chance ONeal. All rights reserved.
//

import Foundation

struct CalculatorBrain {
	// MARK: Properties
	private var accumulator: Double?   // Tracks current value
	private var resultIsPending = false // Tracks if there are pending binary operations.
	private var description = String() // Records the sequence of operations and operands that led to the value returned by "result".
									   
	
	// Enum of operations
	private enum Operation {
		case constant(Double)
		case unaryOperation((Double) -> Double)
		case binaryOperation((Double, Double) -> Double)
		case equals
		case clear
	}
	
	// Dictionary of operations. If the button text matches
	// any of the operations, that operation will be performed.
	private var operations: Dictionary<String, Operation> = [
		"π": Operation.constant(Double.pi),
		"e": Operation.constant(M_E),
		"√": Operation.unaryOperation(sqrt),
		"sin": Operation.unaryOperation(sin),
		"cos": Operation.unaryOperation(cos),
		"tan": Operation.unaryOperation(tan),
		"%": Operation.unaryOperation({ $0 / 100 }),
		"±": Operation.unaryOperation({ -$0 }),
		"+": Operation.binaryOperation({ $0 + $1 }),
		"-": Operation.binaryOperation({ $0 - $1 }),
		"×": Operation.binaryOperation({ $0 * $1 }),
		"÷": Operation.binaryOperation({ $0 / $1 }),
		"=": Operation.equals,
		"C": Operation.clear
	]
	
	mutating func performOperation(_ symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .constant(let value):
				accumulator = value
				resultIsPending = true
			case .unaryOperation(let function):
				if accumulator != nil {
					accumulator = function(accumulator!)
					resultIsPending = false
				}
			case .binaryOperation(let function):
				if accumulator != nil {
					performPendingBinaryOperation()
					pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
					accumulator = nil
				}
			case .equals:
				performPendingBinaryOperation()
				resultIsPending = false
			case .clear:
				resetDisplay()
			}
			
		}
	}
	
	private mutating func resetDisplay() {
		pendingBinaryOperation = nil
		accumulator = 0
		resultIsPending = false
	}
	
	private mutating func performPendingBinaryOperation() {
		if pendingBinaryOperation != nil && accumulator != nil {
			accumulator = pendingBinaryOperation!.perform(with: accumulator!)
			pendingBinaryOperation = nil
		}
	}
	
	private var pendingBinaryOperation: PendingBinaryOperation?
	
	private struct PendingBinaryOperation {
		let function: (Double, Double) -> Double
		let firstOperand: Double
		
		func perform(with secondOperand: Double) -> Double {
			return function(firstOperand, secondOperand)
		}
	}
	
	mutating func setOperand(_ operand: Double) {
		accumulator = operand
	}
	
	var result: Double? {
		get {
			return accumulator
		}
	}
	
	var pendingResult: Bool {
		get {
			return resultIsPending
		}
	}
}
