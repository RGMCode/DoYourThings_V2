//
//  DoYourThingManageCategoriesView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

/*import SwiftUI

struct DoYourThingManageCategoriesView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var isPresentingAddView = false
    @State private var selectedCategory: Category?
    @State private var isShowingDeleteAlert = false
    @State private var categoryToDelete: Category?

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.categories, id: \.self) { category in
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
            CustomStyledButton(title: "Kategorie hinzufügen", backgroundColor: viewModel.themeIconColor) {
                isPresentingAddView = true
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
*/

import SwiftUI

struct DoYourThingManageCategoriesView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var isPresentingAddView = false
    @State private var selectedCategory: Category?
    @State private var isShowingDeleteAlert = false
    @State private var categoryToDelete: Category?

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.categories, id: \.self) { category in
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
                CustomStyledButton(title: NSLocalizedString("addCategory", comment: "Add Category"), backgroundColor: viewModel.themeIconColor) {
                    isPresentingAddView = true
                }
                .padding()
            }
            .navigationBarTitle(NSLocalizedString("manageCategories", comment: "Manage Categories"))
            .sheet(isPresented: $isPresentingAddView) {
                DoYourThingCategoriesAddView(viewModel: viewModel)
            }
            .alert(isPresented: $isShowingDeleteAlert) {
                Alert(
                    title: Text(NSLocalizedString("deleteCategory", comment: "Delete Category")),
                    message: Text(String(format: NSLocalizedString("deleteCategoryConfirmation", comment: "Are you sure you want to delete the category %@?"), categoryToDelete?.name ?? "")),
                    primaryButton: .destructive(Text(NSLocalizedString("delete", comment: "Delete"))) {
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
        .navigationViewStyle(StackNavigationViewStyle()) // Enforce stack navigation style on iPad
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
