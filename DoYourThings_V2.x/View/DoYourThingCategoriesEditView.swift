//
//  DoYourThingCategoriesEditView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

import SwiftUI

struct DoYourThingCategoriesEditView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var category: Category
    @State private var newName: String
    @State private var newColor: Color

    init(viewModel: DoYourThingViewModel, category: Category) {
        self.viewModel = viewModel
        _category = State(initialValue: category)
        _newName = State(initialValue: category.name)
        _newColor = State(initialValue: category.color)
    }

    var body: some View {
        VStack {
            TextField("Kategorie Name", text: $newName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()

            ColorPicker("Kategorie Farbe", selection: $newColor)
                .padding()

            Button(action: {
                viewModel.updateCategory(oldName: category.name, newName: newName, color: newColor)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Änderungen speichern")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Kategorie bearbeiten", displayMode: .inline)
    }
}


#Preview {
    DoYourThingCategoriesEditView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext), category: Category(name: "Test", color: .blue))
}
