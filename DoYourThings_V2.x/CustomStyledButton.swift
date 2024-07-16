//
//  CustomStyledButton.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 16.07.24.
//

import SwiftUI

struct CustomStyledButton: View {
    var title: String
    var backgroundColor: Color = .teal
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(10)
                .padding(.horizontal)
        }
    }
}

#Preview {
    CustomStyledButton(title: "Test Button") {
        print("Button clicked")
    }
}
