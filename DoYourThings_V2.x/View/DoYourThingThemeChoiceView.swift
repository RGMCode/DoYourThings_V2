//
//  DoYourThingThemeChoiceView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

import SwiftUI

struct DoYourThingThemeChoiceView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Theme auswählen")) {
                Picker("Theme", selection: $viewModel.theme) {
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                ColorPicker("Wählen Sie eine Icon-Farbe:", selection: $viewModel.themeIconColor)
            }
        }
        .navigationTitle("Theme Auswahl")
    }
}

#Preview {
    DoYourThingThemeChoiceView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
