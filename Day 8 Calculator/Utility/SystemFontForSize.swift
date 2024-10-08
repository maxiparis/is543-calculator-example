//
//  SystemFontForSize.swift
//  Day 8 Calculator
//
//  Created by Maximiliano París Gaete on 10/7/24.
//

import SwiftUI

func systemFont(for string: String, thatFits width: Double, desiredSize: Double) -> Font {
    var fontSize = desiredSize
    var uiFont = UIFont.systemFont(ofSize: fontSize, weight: .thin)
    
    while (string as NSString).size(withAttributes: [.font: uiFont]).width > width {
        fontSize *= 0.95
        uiFont = UIFont.systemFont(ofSize: fontSize, weight: .thin)
    }
    
    return Font.system(size: fontSize, weight: .thin)
}
