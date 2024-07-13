//
//  DoYourThingManageCategoriesView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct DoYourThingManageCategoriesView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var newCategory: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.categories, id: \.self) { category in
                    Text(category)
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        viewModel.deleteCategory(name: viewModel.categories[index])
                    }
                })
            }
            HStack {
                TextField("Neue Kategorie", text: $newCategory)
                Button(action: {
                    if !newCategory.isEmpty {
                        viewModel.addCategory(name: newCategory)
                        newCategory = ""
                    }
                }) {
                    Text("Hinzufügen")
                }
            }
            .padding()
        }
        .navigationBarTitle("Kategorien verwalten")
    }
}
