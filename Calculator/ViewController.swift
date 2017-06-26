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
			let textCurrentlyInDisplay = display.text!
			display.text = textCurrentlyInDisplay + digit
		} else {
			display.text = digit
			userIsTyping = true
		}
	}
	
	private var brain = CalculatorBrain()
	
	@IBAction func performOperation(_ sender: UIButton) {
		if userIsTyping {
			brain.setOperand(displayValue)
			userIsTyping = false
		}
		if let mathematicalSymbol = sender.currentTitle {
			brain.performOperation(mathematicalSymbol)
		}
		
		if let result = brain.result {
			displayValue = result
		}
	}
	
	
}

