//
//  Category.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var color: Color
    
    // Encode and decode Color to/from a hex string for storage
    var colorHex: String {
        get {
            UIColor(color).toHex() ?? "#000000"
        }
        set {
            if let uiColor = UIColor(hex: newValue) {
                color = Color(uiColor)
            } else {
                color = .black
            }
        }
    }
}
