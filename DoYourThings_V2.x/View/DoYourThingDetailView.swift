//
//  DoYourThingDetailView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct DoYourThingDetailView: View {
    var dyt: DoYourThing
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var isPresentingEditView = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Datum: \(dyt.dytDate, formatter: dateFormatter)")
                Spacer()
                Text("Uhrzeit: \(dyt.dytTime, formatter: timeFormatter)")
            }
            .padding()
            
            Text("Kategorie: \(dyt.dytCategory)")
                .padding()
            
            Text("Priorität: \(dyt.dytPriority)")
                .padding()
            
            HStack {
                Text("Erinnerung:")
                Text("Datum: \(dyt.dytAlarmReminderDate, formatter: dateFormatter)")
                Text("Uhrzeit: \(dyt.dytAlarmReminderTime, formatter: timeFormatter)")
            }.padding()
            
            HStack {
                Text("Deadline:")
                Text("Datum: \(dyt.dytAlarmDeadlineDate, formatter: dateFormatter)")
                Text("Uhrzeit: \(dyt.dytAlarmDeadlineTime, formatter: timeFormatter)")
            }.padding()
            
            Text("Titel: \(dyt.dytTitel)")
                .font(.largeTitle)
                .padding()
            
            Text(dyt.dytDetailtext)
                .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                CustomStyledButton(title: "Bearbeiten", backgroundColor: .teal) {
                    isPresentingEditView = true
                }
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isPresentingEditView) {
                DoYourThingEditView(viewModel: viewModel, task: dyt)
            }
        }
        .navigationTitle(dyt.dytTitel)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}


#Preview {
    let context = PersistenceController.shared.container.viewContext
    let exampleTask = DoYourThing(
        id: UUID(),
        dytTitel: "Beispiel Titel",
        dytDetailtext: "Beispiel Detailtext",
        dytPriority: "Mittel",
        dytCategory: "Privat",
        dytTime: Date(),
        dytDate: Date(),
        dytAlarmReminderDate: Date(),
        dytAlarmReminderTime: Date(),
        dytAlarmDeadlineDate: Date(),
        dytAlarmDeadlineTime: Date()
    )
    let viewModel = DoYourThingViewModel(context: context)
    return DoYourThingDetailView(dyt: exampleTask, viewModel: viewModel)
}
