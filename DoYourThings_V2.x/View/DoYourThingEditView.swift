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
    @State private var category: Category
    @State private var showingDeleteAlert = false

    init(viewModel: DoYourThingViewModel, task: DoYourThing) {
        self.viewModel = viewModel
        self._task = State(initialValue: task)
        self._title = State(initialValue: task.dytTitel)
        self._detail = State(initialValue: task.dytDetailtext)
        self._priority = State(initialValue: task.dytPriority)
        self._category = State(initialValue: viewModel.categories.first { $0.name == task.dytCategory } ?? Category(name: task.dytCategory, color: .gray))
    }

    var body: some View {
        NavigationView {
            VStack {
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
                }
                
                HStack {
                    Spacer()
                    Button(action: {
                        print("Speichern Button gedrückt")
                        let updatedTask = DoYourThing(id: task.id, dytTitel: title, dytDetailtext: detail, dytPriority: priority, dytCategory: category.name, dytTime: task.dytTime, dytDate: task.dytDate)
                        viewModel.updateDYT(task: updatedTask)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Speichern")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    Spacer()
                    Button(action: {
                        print("Löschen Button gedrückt")
                        showingDeleteAlert = true
                    }) {
                        Text("Löschen")
                            .foregroundColor(.red)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 2)
                            )
                    }
                    Spacer()
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Abbrechen") {
                print("Abbrechen Button gedrückt")
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Aufgabe löschen"),
                    message: Text("Sind Sie sicher, dass Sie diese Aufgabe löschen möchten?"),
                    primaryButton: .destructive(Text("Löschen")) {
                        print("Löschen bestätigt")
                        viewModel.deleteDYT(task: task)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel {
                        print("Löschen abgebrochen")
                        showingDeleteAlert = false
                    }
                )
            }
        }
        .onAppear {
        
        }
        .onDisappear {
            if !showingDeleteAlert {
                print("Ansicht verschwindet, Aufgaben werden abgerufen")
                viewModel.fetchDYT()
            }
        }
    }
}

#Preview {
    DoYourThingEditView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext), task: DoYourThing(id: UUID(), dytTitel: "Beispiel", dytDetailtext: "Beispieltext", dytPriority: "Mittel", dytCategory: "Privat", dytTime: Date(), dytDate: Date()))
}
