//
//  DoYourThingSettingView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct DoYourThingSettingView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    
    var body: some View {
        List {
            NavigationLink(destination: DoYourThingManageCategoriesView(viewModel: viewModel)) {
                Text("Kategorien verwalten")
            }
            NavigationLink(destination: DoYourThingThemeChoiceView(viewModel: viewModel)) {
                Text("Theme auswählen")
            }
        }
        .navigationBarTitle("Einstellungen", displayMode: .inline)
    }
}

#Preview {
    DoYourThingSettingView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
