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
            Section(header: Text(NSLocalizedString("chooseTheme", comment: "Choose Theme"))) {
                Picker(NSLocalizedString("theme", comment: "Theme"), selection: $viewModel.theme) {
                    Text(NSLocalizedString("light", comment: "Light")).tag("Light")
                    Text(NSLocalizedString("dark", comment: "Dark")).tag("Dark")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                ColorPicker(NSLocalizedString("chooseIconColor", comment: "Choose an Icon Color:"), selection: $viewModel.themeIconColor)
            }
        }
        .navigationTitle(NSLocalizedString("themeChoice", comment: "Theme Choice"))
    }
}

#Preview {
    DoYourThingThemeChoiceView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
