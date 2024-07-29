//
//  DoYourThingCategoriesEditView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

import SwiftUI

struct DoYourThingCategoriesEditView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var category: Category
    @Environment(\.presentationMode) private var presentationMode
    @State private var isShowingDeleteAlert = false
    private var originalCategoryName: String

    init(viewModel: DoYourThingViewModel, category: Category) {
        self.viewModel = viewModel
        self._category = State(initialValue: category)
        self.originalCategoryName = category.name
    }

    var body: some View {
        Form {
            Section(header: Text("Kategorie bearbeiten")) {
                TextField("Name", text: $category.name)
                ColorPicker("Farbe", selection: $category.color)
            }
            Section {
                CustomStyledButton(title: "Speichern") {
                    viewModel.updateCategory(oldName: originalCategoryName, newName: category.name, color: category.color)
                    presentationMode.wrappedValue.dismiss()
                }

                CustomStyledButton(title: "Löschen", backgroundColor: .red) {
                    isShowingDeleteAlert = true
                }
            }
        }
        .navigationTitle("Kategorie bearbeiten")
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text("Kategorie löschen"),
                message: Text("Sind Sie sicher, dass Sie die Kategorie „\(category.name)“ löschen möchten? (Es werden alle dazugehörigen Aufgaben mit gelöscht!)"),
                primaryButton: .destructive(Text("Löschen")) {
                    viewModel.deleteCategory(name: category.name)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    DoYourThingCategoriesEditView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext), category: Category(name: "Test", color: .blue))
}
