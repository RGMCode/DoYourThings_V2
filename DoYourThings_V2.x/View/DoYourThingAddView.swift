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
    @State private var priority: String = NSLocalizedString("medium", comment: "Medium")
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
        self._category = State(initialValue: viewModel.categories.first ?? Category(originalName: "Default", color: .gray))
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(NSLocalizedString("category", comment: "Category"))) {
                    Picker(NSLocalizedString("category", comment: "Category"), selection: $category) {
                        ForEach(viewModel.categories) { category in
                            Text(category.name).tag(category)
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("priority", comment: "Priority"))) {
                    Picker(NSLocalizedString("priority", comment: "Priority"), selection: $priority) {
                        Text(NSLocalizedString("veryHigh", comment: "Very High")).tag(NSLocalizedString("veryHigh", comment: "Very High"))
                        Text(NSLocalizedString("high", comment: "High")).tag(NSLocalizedString("high", comment: "High"))
                        Text(NSLocalizedString("medium", comment: "Medium")).tag(NSLocalizedString("medium", comment: "Medium"))
                        Text(NSLocalizedString("low", comment: "Low")).tag(NSLocalizedString("low", comment: "Low"))
                        Text(NSLocalizedString("veryLow", comment: "Very Low")).tag(NSLocalizedString("veryLow", comment: "Very Low"))
                    }
                }

                Section(header: Text(NSLocalizedString("reminder", comment: "Reminder"))) {
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
                                DatePicker(NSLocalizedString("chooseDate", comment: "Choose Date"), selection: $alarmReminderDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                CustomStyledButton(title: NSLocalizedString("continue", comment: "Continue")) {
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
                                CustomStyledButton(title: NSLocalizedString("done", comment: "Done")) {
                                    showingReminderTimePicker = false
                                }
                            }
                            .padding()
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("deadline", comment: "Deadline"))) {
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
                                DatePicker(NSLocalizedString("chooseDate", comment: "Choose Date"), selection: $alarmDeadlineDate, displayedComponents: .date)
                                    .datePickerStyle(GraphicalDatePickerStyle())
                                CustomStyledButton(title: NSLocalizedString("continue", comment: "Continue")) {
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
                                CustomStyledButton(title: NSLocalizedString("done", comment: "Done")) {
                                    showingDeadlineTimePicker = false
                                }
                            }
                            .padding()
                        }
                    }
                }

                Section(header: Text(NSLocalizedString("title", comment: "Title"))) {
                    TextField(NSLocalizedString("title", comment: "Title"), text: $title)
                }

                Section(header: Text(NSLocalizedString("detail", comment: "Detail"))) {
                    TextEditor(text: $detail)
                        .frame(minHeight: 90, maxHeight: .infinity)
                }

                CustomStyledButton(title: NSLocalizedString("addTask", comment: "Add Task")) {
                    let currentDate = Date()
                    let newTask = DoYourThing(
                        id: UUID(),
                        dytTitel: title,
                        dytDetailtext: detail,
                        dytPriority: priority,
                        dytCategory: category.originalName,
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
                        category: category.originalName,
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
            .navigationBarTitle(NSLocalizedString("newTask", comment: "New Task"))
            .toolbarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(NSLocalizedString("cancel", comment: "Cancel")) {
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
