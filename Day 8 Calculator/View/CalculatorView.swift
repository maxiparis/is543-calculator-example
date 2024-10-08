//
//  CalculatorView.swift
//  HW4 Calculator UI
//
//  Created by Stephen Liddle on 9/24/24.
//

import SwiftUI

let columnCount = 4
let gridItems = Array<GridItem>(repeating: .init(.flexible()), count: columnCount)

struct CalculatorView: View {

    private struct Constants {
        static let displayFontSize = 90.0
    }

    @Bindable var calculatorViewModel: CalculatorViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(.black)
                    .ignoresSafeArea(.all)
                VStack(alignment: .trailing, spacing: DrawingConstants.buttonSpacing) {
                    Toggle(
                        "Play sound",
                        isOn: $calculatorViewModel.preferences.soundIsEnabled
                    )
                        .foregroundStyle(.white)
                    Spacer()
                    Text(calculatorViewModel.displayText)
                        .font(.system(size: Constants.displayFontSize, weight: .thin))
                        .foregroundStyle(.white)
                        .padding(.trailing, DrawingConstants.buttonSpacing)
                    LazyVGrid(columns: gridItems, alignment: .leading, spacing: DrawingConstants.buttonSpacing) {
                        ForEach(buttonSpecs, id: \.symbol.rawValue) { buttonSpec in
                            if buttonSpec.symbol == .placeholder {
                                Text("")
                            } else {
                                CalculatorButton(
                                    buttonSpec: buttonSpec,
                                    size: geometry.size,
                                    calculatorViewModel: calculatorViewModel
                                )
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}

//#Preview {
//    CalculatorView()
//}
