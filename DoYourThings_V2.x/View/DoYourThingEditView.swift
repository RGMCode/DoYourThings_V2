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
    @State private var alarmReminderDate: Date
    @State private var alarmReminderTime: Date
    @State private var alarmDeadlineDate: Date
    @State private var alarmDeadlineTime: Date
    @State private var showingReminderDatePicker = false
    @State private var showingReminderTimePicker = false
    @State private var showingDeadlineDatePicker = false
    @State private var showingDeadlineTimePicker = false
    @State private var showingDeleteAlert = false

    init(viewModel: DoYourThingViewModel, task: DoYourThing) {
        self.viewModel = viewModel
        self._task = State(initialValue: task)
        self._title = State(initialValue: task.dytTitel)
        self._detail = State(initialValue: task.dytDetailtext)
        self._priority = State(initialValue: task.dytPriority)
        self._category = State(initialValue: viewModel.categories.first { $0.name == task.dytCategory } ?? Category(name: task.dytCategory, color: .gray))
        self._alarmReminderDate = State(initialValue: task.dytAlarmReminderDate)
        self._alarmReminderTime = State(initialValue: task.dytAlarmReminderTime)
        self._alarmDeadlineDate = State(initialValue: task.dytAlarmDeadlineDate)
        self._alarmDeadlineTime = State(initialValue: task.dytAlarmDeadlineTime)
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
                        .frame(minHeight: 100, maxHeight: .infinity)
                }
                
                CustomStyledButton(title: "Speichern") {
                    print("Speichern Button gedrückt")
                    let updatedTask = DoYourThing(
                        id: task.id,
                        dytTitel: title,
                        dytDetailtext: detail,
                        dytPriority: priority,
                        dytCategory: category.name,
                        dytTime: task.dytTime,
                        dytDate: task.dytDate,
                        dytAlarmReminderDate: alarmReminderDate,
                        dytAlarmReminderTime: alarmReminderTime,
                        dytAlarmDeadlineDate: alarmDeadlineDate,
                        dytAlarmDeadlineTime: alarmDeadlineTime
                    )
                    viewModel.updateDYT(task: updatedTask)
                    NotificationManager.shared.removeNotification(task: task)
                    NotificationManager.shared.scheduleNotification(task: updatedTask, isReminder: true)
                    NotificationManager.shared.scheduleNotification(task: updatedTask, isReminder: false)
                    presentationMode.wrappedValue.dismiss()
                }
                
                CustomStyledButton(title: "Löschen", backgroundColor: .red) {
                    print("Löschen Button gedrückt")
                    showingDeleteAlert = true
                }
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
                        NotificationManager.shared.removeNotification(task: task)
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
            print("EditView erscheint")
        }
        .onDisappear {
            if !showingDeleteAlert {
                print("Ansicht verschwindet, Aufgaben werden abgerufen")
                viewModel.fetchDYT()
            }
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
    DoYourThingEditView(
        viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext),
        task: DoYourThing(
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
    )
}
