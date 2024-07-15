//
//  DoYourThingAddView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct DoYourThingAddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var priority: String = "Mittel"
    @State private var category: Category
    
    init(viewModel: DoYourThingViewModel) {
        self.viewModel = viewModel
        self._category = State(initialValue: viewModel.categories.first ?? Category(name: "Default", color: .gray))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kategorie")) {
                    Picker("Kategorie", selection: $category) {
                        ForEach(viewModel.categories) { category in
                            Text(category.name).tag(category)
                        }
                    }
                }
                
                Section(header: Text("Priorität")) {
                    Picker("Priorität", selection: $priority) {
                        Text("Sehr Hoch").tag("Sehr Hoch")
                        Text("Hoch").tag("Hoch")
                        Text("Mittel").tag("Mittel")
                        Text("Niedrig").tag("Niedrig")
                        Text("Sehr Niedrig").tag("Sehr Niedrig")
                    }
                }
                
                Section(header: Text("Titel")) {
                    TextField("Titel", text: $title)
                }
                
                Section(header: Text("Detailtext")) {
                    TextEditor(text: $detail)
                        .frame(minHeight: 100, maxHeight: .infinity)
                }
                
                Section {
                    Button(action: {
                        let currentDate = Date()
                        viewModel.addDYT(title: title, detail: detail, priority: priority, category: category.name, date: currentDate, time: currentDate)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                                Spacer()
                                Text("Aufgabe hinzufügen")
                                Spacer()
                            }
                    }
                }
            }
            .navigationBarTitle("Neue Aufgabe")
            .navigationBarItems(trailing: Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    DoYourThingAddView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
