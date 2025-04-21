//
//  ViewController.swift
//  iCommunity-CalculatorApp
//
//  Created by AHMET HAKAN YILDIRIM on 20.04.2025.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet private var resultLabel: UILabel!
    
    private let calculatorModel = CalculatorModel()
    private var isTypingNumber = false
    
    private var selectedOperator: Operation?
    private var firstOperand: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = "0"
    }
    
    // MARK: - Actions
    
    // 0–9 arası butonlar için tag: 0–9
    @IBAction func numberPressed(_ sender: UIButton) {
        let numberText = String(sender.tag)
        
        if isTypingNumber {
            resultLabel.text! += numberText
        } else {
            if let op = selectedOperator, let first = firstOperand {
                resultLabel.text = first + " " + op.rawValue + " " + numberText
            } else {
                resultLabel.text = numberText
            }
            isTypingNumber = true
        }
    }
    
    // İşlemler için:
    @IBAction func operationPressed(_ sender: UIButton) {
        switch sender.tag {
        case 16:
            selectedOperator = .add
        case 15:
            selectedOperator = .subtract
        case 14:
            selectedOperator = .multiply
        case 13:
            selectedOperator = .divide
        case 12:
            selectedOperator = .mod
        default:
            selectedOperator = nil
        }

        if let text = resultLabel.text {
            calculatorModel.inputNumber(text)
            firstOperand = text
            if let op = selectedOperator {
                calculatorModel.setOperation(op)
                resultLabel.text = "\(text) \(op.rawValue)"
            }
        }

        isTypingNumber = false
    }
    
    
    @IBAction func equalPressed(_ sender: UIButton) {
        guard let text = resultLabel.text else { return }
        let components = text.components(separatedBy: " ")

        if components.count == 3 {
            let firstValue = components[0]
            let operation = components[1]
            var secondValue = components[2]

            // "(-3)" → "-3"
            secondValue = secondValue
                .replacingOccurrences(of: "(", with: "")
                .replacingOccurrences(of: ")", with: "")

            calculatorModel.inputNumber(firstValue)
            guard let op = Operation(rawValue: operation) else {return}
            calculatorModel.setOperation(op)
            let result = calculatorModel.calculate(with: secondValue)
            resultLabel.text = result
        }

        isTypingNumber = false
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        calculatorModel.clear()
        resultLabel.text = "0"
        selectedOperator = nil
        firstOperand = nil
        isTypingNumber = false
    }
    
    @IBAction func decimalPressed(_ sender: UIButton) {
        guard let text = resultLabel.text else { return }
        
        if isTypingNumber && !text.contains(".") {
            resultLabel.text = text + "."
        } else if !isTypingNumber {
            resultLabel.text = "0."
            isTypingNumber = true
        }
    }
    
    @IBAction func toggleSignPressed(_ sender: UIButton) {
        guard let text = resultLabel.text else { return }

        if text.contains(" ") {
            var components = text.components(separatedBy: " ")
            if let last = components.last,
               var value = Double(last) {
                value *= -1
                components[components.count - 1] = "(" + String(Int(value)) + ")"
                resultLabel.text = components.joined(separator: " ")
            }
        } else {
            if var value = Double(text) {
                value *= -1
                resultLabel.text = String(value)
            }
        }
    }
}
