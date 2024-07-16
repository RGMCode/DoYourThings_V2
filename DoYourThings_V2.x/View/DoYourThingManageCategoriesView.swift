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
    @State private var isShowingDeleteAlert = false
    @State private var categoryToDelete: Category?

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.categories, id: \.id) { category in
                    NavigationLink(
                        destination: DoYourThingCategoriesEditView(viewModel: viewModel, category: category)
                    ) {
                        HStack {
                            Text(category.name)
                            Spacer()
                            Image(systemName: "square.fill")
                                                    .foregroundColor(category.color)
                                                    .font(.system(size: 30))
                        }
                    }
                }
                .onDelete(perform: handleDelete)
            }
            Button(action: {
                isPresentingAddView = true
            }) {
                Text("Kategorie hinzufügen")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .sheet(isPresented: $isPresentingAddView) {
            DoYourThingCategoriesAddView(viewModel: viewModel)
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text("Kategorie löschen"),
                message: Text("Sind Sie sicher, dass Sie die Kategorie „\(categoryToDelete?.name ?? "")“ löschen möchten?"),
                primaryButton: .destructive(Text("Löschen")) {
                    if let category = categoryToDelete {
                        viewModel.deleteCategory(name: category.name)
                        categoryToDelete = nil
                    }
                    isShowingDeleteAlert = false
                },
                secondaryButton: .cancel {
                    categoryToDelete = nil
                    isShowingDeleteAlert = false
                }
            )
        }
    }

    private func handleDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            if viewModel.categories.count > 1 {
                categoryToDelete = viewModel.categories[index]
                isShowingDeleteAlert = true
            } else {
                isShowingDeleteAlert = true
            }
        }
    }
}
