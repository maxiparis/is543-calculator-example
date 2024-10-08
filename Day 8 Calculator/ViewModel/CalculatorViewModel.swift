//
//  CalculatorViewModel.swift
//  Day 8 Calculator
//
//  Created by Stephen Liddle on 9/26/24.
//

import Foundation

@Observable class CalculatorViewModel {

    //MARK: - Constants
    private struct Constants {
        static let decimal = OperationSymbol.decimal.rawValue
        static let defaultDisplayText = OperationSymbol.zero.rawValue
        static let errorDisplay = "Error"
        static let maximumFractionDigits = 8
        static let largeThreshold = 1_000_000_000.0
    }

    
    // MARK: - Properties

    var preferences = Preferences()

    private var decimalFormatter = NumberFormatter()
    private var scientificFormatter = NumberFormatter()
    private var calculatorModel = CalculatorBrain()
    private var soundPlayer = SoundPlayer()
    private var textBeingEdited: String? = Constants.defaultDisplayText
    
    //MARK: - Initializer
    
    init(){
        decimalFormatter.numberStyle = .decimal
        decimalFormatter.maximumFractionDigits = Constants.maximumFractionDigits
        
        scientificFormatter.numberStyle = .scientific
        scientificFormatter.maximumFractionDigits = Constants.maximumFractionDigits
    }


    // MARK: - Model access
    
    var activeSymbol: OperationSymbol? {
        calculatorModel.pendingSymbol
    }
    
    var displayText: String {
        if let textBeingEdited {
            textBeingEdited
        } else if let value = calculatorModel.accumulator {
            formatted(number: value)
        } else if let value = calculatorModel.pendingLeftOperand {
            formatted(number: value)
        } else {
            Constants.errorDisplay
        }
    }

    // MARK: - User intents

    func handleButtonTap(for buttonSpec: ButtonSpec) {
        if preferences.soundIsEnabled {
            Task {
                await soundPlayer.playSound(named: "Click2.m4a")
            }
        }
        
        switch buttonSpec.type {
        case .compute:
            handleOperationTap(symbol: buttonSpec.symbol)
        case .utility:
            if buttonSpec.symbol == .clear {
                handleClearTap()
            } else {
                handleOperationTap(symbol: buttonSpec.symbol)
            }
        case .number, .doubleWide:
            handleNumericTap(digit: buttonSpec.symbol.rawValue)
        }
        
    }

    // MARK: - Private Helpers
    
    private func formatted(number: Double) -> String {
        formatter(for: number).string(from: NSNumber(value: number)) ?? Constants.errorDisplay
    }
    
    private func formatter(for value: Double) -> NumberFormatter {
        value > Constants.largeThreshold ? scientificFormatter : decimalFormatter
    }
    
    private func handleClearTap() {
        
    }
    
    private func handleNumericTap(digit: String) {
        if let text = textBeingEdited {
            if digit == Constants.decimal && text.contains(digit) {
                // Ignore extra tap on decimal
                return
            }
            
            if digit != Constants.decimal && text == Constants.defaultDisplayText {
                textBeingEdited = digit
            } else {
                textBeingEdited = text + digit
            }
        } else {
            textBeingEdited = digit
        }
        
        if let updatedText = textBeingEdited {
            calculatorModel.setAccumulator(Double(updatedText))
        }
    }
    
    private func handleOperationTap(symbol: OperationSymbol) {
        if calculatorModel.accumulator != nil {
            calculatorModel.performOperation(symbol)
            textBeingEdited = nil
        }
        
    }
}
