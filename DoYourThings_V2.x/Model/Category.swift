//
//  Category.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

import SwiftUI

struct Category: Identifiable, Hashable {
    var id = UUID()
    var originalName: String
    var color: Color
    
    var name: String {
        get {
            UserDefaults.standard.string(forKey: "\(id.uuidString)_name") ?? NSLocalizedString(originalName, comment: "")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(id.uuidString)_name")
        }
    }
    
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
