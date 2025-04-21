//
//  CalculatorModel.swift
//  iCommunity-CalculatorApp
//
//  Created by AHMET HAKAN YILDIRIM on 21.04.2025.
//

import Foundation

// operasyonlar
enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    case mod = "%"
}

class CalculatorModel {
    private var currentValue: Double = 0
    private var previousValue: Double = 0
    private var currentOperation: Operation?

    
    func inputNumber(_ number: String) {
        currentValue = Double(number) ?? 0
    }

    // Operasyon set etme
    func setOperation(_ operation: Operation) {
        currentOperation = operation
        previousValue = currentValue
    }

    // İşlem Hesaplama fonksiyonu
    func calculate(with value: String) -> String {
        let newValue = Double(value) ?? 0
        guard let op = currentOperation else { return value }

        let result: Double

        switch op {
        case .add:
            result = previousValue + newValue
        case .subtract:
            result = previousValue - newValue
        case .multiply:
            result = previousValue * newValue
        case .divide:
            result = newValue != 0 ? previousValue / newValue : 0
        case .mod:
            result = Double(Int(previousValue) % Int(newValue))
        }

        currentValue = result
        return String(result)
    }

    // Temizleme işlemi
    func clear() {
        currentValue = 0
        previousValue = 0
        currentOperation = nil
    }
}
