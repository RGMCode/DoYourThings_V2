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
                Text("\(NSLocalizedString("date", comment: "Date")): \(dyt.dytDate, formatter: dateFormatter)")
                Spacer()
                Text("\(NSLocalizedString("time", comment: "Time")): \(dyt.dytTime, formatter: timeFormatter)")
            }
            .padding()
            
            Text("\(NSLocalizedString("category", comment: "Category")): \(dyt.dytCategory)")
                .padding()
            
            Text("\(NSLocalizedString("priority", comment: "Priority")): \(localizedPriority(for: dyt.dytPriority))")
                .padding()
            
            HStack {
                Text("\(NSLocalizedString("reminder", comment: "Reminder")):")
                Text("\(NSLocalizedString("date", comment: "Date")): \(dyt.dytAlarmReminderDate, formatter: dateFormatter)")
                Text("\(NSLocalizedString("time", comment: "Time")): \(dyt.dytAlarmReminderTime, formatter: timeFormatter)")
            }.padding()
            
            HStack {
                Text("\(NSLocalizedString("deadline", comment: "Deadline")):")
                Text("\(NSLocalizedString("date", comment: "Date")): \(dyt.dytAlarmDeadlineDate, formatter: dateFormatter)")
                Text("\(NSLocalizedString("time", comment: "Time")): \(dyt.dytAlarmDeadlineTime, formatter: timeFormatter)")
            }.padding()
            
            Text("\(NSLocalizedString("title", comment: "Title")): \(dyt.dytTitel)")
                .font(.largeTitle)
                .padding()
            
            Text(dyt.dytDetailtext)
                .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                CustomStyledButton(title: NSLocalizedString("edit", comment: "Edit"), backgroundColor: .teal) {
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
    
    private func localizedPriority(for priority: String) -> String {
        switch priority {
        case "Sehr Hoch":
            return NSLocalizedString("veryHigh", comment: "Very High")
        case "Hoch":
            return NSLocalizedString("high", comment: "High")
        case "Mittel":
            return NSLocalizedString("medium", comment: "Medium")
        case "Niedrig":
            return NSLocalizedString("low", comment: "Low")
        case "Sehr Niedrig":
            return NSLocalizedString("veryLow", comment: "Very Low")
        default:
            return priority
        }
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

