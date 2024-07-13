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
        NavigationView {
            List {
                NavigationLink(destination: DoYourThingManageCategoriesView(viewModel: viewModel)) {
                    Text("Kategorien verwalten")
                }
            }
            .navigationBarTitle("Einstellungen")
        }
    }
}




