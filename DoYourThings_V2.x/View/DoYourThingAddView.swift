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
    @State private var alarmReminderDate: Date = Date()
    @State private var alarmReminderTime: Date = Date()
    @State private var alarmDeadlineDate: Date = Date()
    @State private var alarmDeadlineTime: Date = Date()
    @State private var showingReminderDatePicker = false
    @State private var showingReminderTimePicker = false
    @State private var showingDeadlineDatePicker = false
    @State private var showingDeadlineTimePicker = false

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

                Section(header: Text("Erinnerung:")) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                        Button(action: {
                            showingReminderDatePicker.toggle()
                        }) {
                            Text("\(alarmReminderDate, formatter: dateFormatter)")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showingReminderDatePicker) {
                            VStack {
                                DatePicker("Datum wählen", selection: $alarmReminderDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                CustomStyledButton(title: "Weiter") {
                                    showingReminderDatePicker = false
                                }
                            }
                            .padding()
                        }

                        Spacer()

                        Image(systemName: "alarm.fill")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                        Button(action: {
                            showingReminderTimePicker.toggle()
                        }) {
                            Text("\(alarmReminderTime, formatter: timeFormatter)")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showingReminderTimePicker) {
                            VStack {
                                DatePicker("", selection: $alarmReminderTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                CustomStyledButton(title: "Fertig") {
                                    showingReminderTimePicker = false
                                }
                            }
                            .padding()
                        }
                    }
                }

                Section(header: Text("Enddatum/Deadline:")) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                        Button(action: {
                            showingDeadlineDatePicker.toggle()
                        }) {
                            Text("\(alarmDeadlineDate, formatter: dateFormatter)")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showingDeadlineDatePicker) {
                            VStack {
                                DatePicker("Datum wählen", selection: $alarmDeadlineDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                CustomStyledButton(title: "Weiter") {
                                    showingDeadlineDatePicker = false
                                }
                            }
                            .padding()
                        }

                        Spacer()

                        Image(systemName: "alarm.fill")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                        Button(action: {
                            showingDeadlineTimePicker.toggle()
                        }) {
                            Text("\(alarmDeadlineTime, formatter: timeFormatter)")
                                .foregroundColor(.black)
                        }
                        .sheet(isPresented: $showingDeadlineTimePicker) {
                            VStack {
                                DatePicker("", selection: $alarmDeadlineTime, displayedComponents: .hourAndMinute)
                                    .datePickerStyle(WheelDatePickerStyle())
                                CustomStyledButton(title: "Fertig") {
                                    showingDeadlineTimePicker = false
                                }
                            }
                            .padding()
                        }
                    }
                }

                Section(header: Text("Titel")) {
                    TextField("Titel", text: $title)
                }

                Section(header: Text("Detailtext")) {
                    TextEditor(text: $detail)
                        .frame(minHeight: 90, maxHeight: .infinity)
                }

                CustomStyledButton(title: "Aufgabe hinzufügen") {
                    let currentDate = Date()
                    let newTask = DoYourThing(
                        id: UUID(),
                        dytTitel: title,
                        dytDetailtext: detail,
                        dytPriority: priority,
                        dytCategory: category.name,
                        dytTime: currentDate,
                        dytDate: currentDate,
                        dytAlarmReminderDate: alarmReminderDate,
                        dytAlarmReminderTime: alarmReminderTime,
                        dytAlarmDeadlineDate: alarmDeadlineDate,
                        dytAlarmDeadlineTime: alarmDeadlineTime
                    )
                    viewModel.addDYT(
                        title: title,
                        detail: detail,
                        priority: priority,
                        category: category.name,
                        date: currentDate,
                        time: currentDate,
                        alarmReminderDate: alarmReminderDate,
                        alarmReminderTime: alarmReminderTime,
                        alarmDeadlineDate: alarmDeadlineDate,
                        alarmDeadlineTime: alarmDeadlineTime
                    )
                    NotificationManager.shared.scheduleNotification(task: newTask, isReminder: true)
                    NotificationManager.shared.scheduleNotification(task: newTask, isReminder: false)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Neue Aufgabe")
            .toolbarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Abbrechen") {
                presentationMode.wrappedValue.dismiss()
            })
        }
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
    DoYourThingAddView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
