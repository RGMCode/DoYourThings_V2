//
//  DoYourThingCategoriesAddView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

/*import SwiftUI

struct DoYourThingCategoriesAddView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var newName: String = ""
    @State private var newColor: Color = .blue

    var body: some View {
        VStack {
            TextField("Kategorie Name", text: $newName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()

            ColorPicker("Kategorie Farbe", selection: $newColor)
                .padding()

            CustomStyledButton(title: "Kategorie hinzufügen") {
                viewModel.addCategory(name: newName, color: newColor)
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DoYourThingCategoriesAddView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
*/

import SwiftUI

struct DoYourThingCategoriesAddView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var newName: String = ""
    @State private var newColor: Color = .blue

    var body: some View {
        VStack {
            TextField("Kategorie Name", text: $newName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding()

            ColorPicker("Kategorie Farbe", selection: $newColor)
                .padding()

            CustomStyledButton(title: "Kategorie hinzufügen") {
                //viewModel.addCategory(name: newName, originalName: newName, color: newColor)
                presentationMode.wrappedValue.dismiss()
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DoYourThingCategoriesAddView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
