//
//  DoYourThingCategoriesEditView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

/*import SwiftUI

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
*/


/*import SwiftUI

struct DoYourThingCategoriesEditView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var category: Category
    @Environment(\.presentationMode) private var presentationMode
    @State private var isShowingDeleteAlert = false

    init(viewModel: DoYourThingViewModel, category: Category) {
        self.viewModel = viewModel
        self._category = State(initialValue: category)
    }

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("editCategory", comment: "Edit Category"))) {
                TextField(NSLocalizedString("name", comment: "Name"), text: $category.name)
                ColorPicker(NSLocalizedString("color", comment: "Color"), selection: $category.color)
            }
            Section {
                CustomStyledButton(title: NSLocalizedString("save", comment: "Save")) {
                    viewModel.updateCategory(oldName: category.name, newName: category.name, color: category.color)
                    presentationMode.wrappedValue.dismiss()
                }

                CustomStyledButton(title: NSLocalizedString("delete", comment: "Delete"), backgroundColor: .red) {
                    isShowingDeleteAlert = true
                }
            }
        }
        .navigationTitle(NSLocalizedString("editCategory", comment: "Edit Category"))
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text(NSLocalizedString("deleteCategory", comment: "Delete Category")),
                message: Text(String(format: NSLocalizedString("deleteCategoryConfirmation", comment: "Are you sure you want to delete the category %@?"), category.name)),
                primaryButton: .destructive(Text(NSLocalizedString("delete", comment: "Delete"))) {
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
*/

import SwiftUI

struct DoYourThingCategoriesEditView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var category: Category
    @Environment(\.presentationMode) private var presentationMode
    @State private var isShowingDeleteAlert = false

    init(viewModel: DoYourThingViewModel, category: Category) {
        self.viewModel = viewModel
        self._category = State(initialValue: category)
    }

    var body: some View {
        Form {
            Section(header: Text(NSLocalizedString("editCategory", comment: "Edit Category"))) {
                TextField(NSLocalizedString("categoryName", comment: "Category Name"), text: $category.name)
                ColorPicker(NSLocalizedString("categoryColor", comment: "Category Color"), selection: $category.color)
            }
            Section {
                CustomStyledButton(title: NSLocalizedString("save", comment: "Save")) {
                    viewModel.updateCategory(oldName: category.originalName, newName: category.name, color: category.color)
                    presentationMode.wrappedValue.dismiss()
                }

                CustomStyledButton(title: NSLocalizedString("delete", comment: "Delete"), backgroundColor: .red) {
                    isShowingDeleteAlert = true
                }
            }
        }
        .navigationTitle(NSLocalizedString("editCategory", comment: "Edit Category"))
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text(NSLocalizedString("deleteCategory", comment: "Delete Category")),
                message: Text(String(format: NSLocalizedString("deleteCategoryConfirmation", comment: "Are you sure you want to delete the category %@?"), category.name)),
                primaryButton: .destructive(Text(NSLocalizedString("delete", comment: "Delete"))) {
                    viewModel.deleteCategory(name: category.originalName)
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    DoYourThingCategoriesEditView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext), category: Category(originalName: "privateCategory", color: .blue))
}
