//
//  DoYourThingManageCategoriesView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct DoYourThingManageCategoriesView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var isPresentingAddView = false
    @State private var selectedCategory: Category?

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button(action: {
                        DispatchQueue.main.async {
                            selectedCategory = category
                        }
                    }) {
                        HStack {
                            Text(category.name)
                            Spacer()
                            Circle()
                                .fill(category.color)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .sheet(item: $selectedCategory) { category in
                DoYourThingCategoriesEditView(viewModel: viewModel, category: category)
            }

            Button(action: {
                DispatchQueue.main.async {
                    isPresentingAddView = true
                }
            }) {
                Text("Neue Kategorie hinzufügen")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .sheet(isPresented: $isPresentingAddView) {
                DoYourThingCategoriesAddView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Kategorien verwalten", displayMode: .inline)
    }
}
