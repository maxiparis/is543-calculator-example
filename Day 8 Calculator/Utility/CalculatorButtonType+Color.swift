//
//  CalculatorButtonType+Color.swift
//  Day 8 Calculator
//
//  Created by Stephen Liddle on 10/1/24.
//

import SwiftUI

extension CalculatorButtonType {
    var backgroundColor: Color {
        switch self {
            case .utility:
                .utilityBackground
            case .compute:
                .computeBackground
            case .number, .doubleWide:
                .numberBackground
        }
    }

    var foregroundColor: Color {
        self == .utility ? .black : .white
    }

    var spanWidth: Int {
        self == .doubleWide ? 2 : 1
    }
}
