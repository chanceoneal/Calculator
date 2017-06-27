//
//  ViewController.swift
//  Calculator
//
//  Created by Chance ONeal on 6/24/17.
//  Copyright © 2017 Chance ONeal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	// MARK: Properties
	@IBOutlet weak var display: UILabel!
	@IBOutlet weak var previousOperations: UILabel!
	var userIsTyping = false
	var displayValue: Double {
		get {
			return Double(display.text!)!
		}
		set {
			display.text = String(newValue)
		}
	}
	
	
	// MARK: Actions
	@IBAction func touchDigit(_ sender: UIButton) {
		let digit = sender.currentTitle!
		if userIsTyping {
			if digit != "." || (digit == "." && !display.text!.contains(".")) {
				let textCurrentlyInDisplay = display.text!
//				let previousOperationsInDisplay = previousOperations.text!
				display.text = textCurrentlyInDisplay + digit
//				previousOperations.text = previousOperationsInDisplay + digit
			}
		} else {
			if digit == "." {
				display.text = "0" + digit
			} else {
				display.text = digit
			}
			userIsTyping = true
		}
	}
	
	private var brain = CalculatorBrain()
	
	@IBAction func performOperation(_ sender: UIButton) {
		if userIsTyping {
			brain.setOperand(displayValue)
			userIsTyping = false
			let previousOperationsInDisplay = previousOperations.text!
			previousOperations.text = previousOperationsInDisplay + String(displayValue)

		}
		
		if let mathematicalSymbol = sender.currentTitle {
			brain.performOperation(mathematicalSymbol)
			let previousOperationsInDisplay = previousOperations.text!
			previousOperations.text = previousOperationsInDisplay + mathematicalSymbol
		}
		
		if let result = brain.result {
			if sender.currentTitle == "C" {
				display.text = "0"
				previousOperations.text = " "
			} else {
				displayValue = result
			}
		}
		
		if brain.pendingResult {
			let previousOperationsInDisplay = previousOperations.text!
			previousOperations.text = previousOperationsInDisplay + "..."
		}
//		} else {
//			let previousOperationsInDisplay = previousOperations.text!
//			previousOperations.text = previousOperationsInDisplay + "="
//		}
	}
	
	
}

