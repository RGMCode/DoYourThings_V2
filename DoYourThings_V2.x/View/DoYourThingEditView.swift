//
//  DoYourThingEditView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct DoYourThingEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DoYourThingViewModel
    @State var task: DoYourThing
    @State private var title: String
    @State private var detail: String
    @State private var priority: String
    @State private var category: String
    
    init(viewModel: DoYourThingViewModel, task: DoYourThing) {
        self.viewModel = viewModel
        self._task = State(initialValue: task)
        self._title = State(initialValue: task.dytTitel)
        self._detail = State(initialValue: task.dytDetailtext)
        self._priority = State(initialValue: task.dytPriority)
        self._category = State(initialValue: task.dytCategory)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kategorie")) {
                    Picker("Kategorie", selection: $category) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category).tag(category)
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
                        viewModel.updateDYT(task: DoYourThing(id: task.id, dytTitel: title, dytDetailtext: detail, dytPriority: priority, dytCategory: category, dytTime: currentDate, dytDate: currentDate))
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Änderungen speichern")
                    }
                }
            }
            .navigationBarTitle("Aufgabe bearbeiten")
            .navigationBarItems(trailing: Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


/*#Preview {
    DoYourThingEditView()
}*/
