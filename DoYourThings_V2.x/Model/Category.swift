//
//  Category.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

/*import SwiftUI

struct Category: Identifiable, Hashable {
    var id = UUID()
    //var name: String
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
}*/


import SwiftUI

struct Category: Identifiable, Hashable {
    var id = UUID()
    var originalName: String
    var color: Color
    
    var name: String {
        get {
            // Return the localized name if the original name has not been changed
            UserDefaults.standard.string(forKey: "\(id.uuidString)_name") ?? NSLocalizedString(originalName, comment: "")
        }
        set {
            // Save the new name to UserDefaults
            UserDefaults.standard.set(newValue, forKey: "\(id.uuidString)_name")
        }
    }
    
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
