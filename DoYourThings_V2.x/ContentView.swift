//
//  ContentView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DoYourThingViewModel(context: PersistenceController.shared.container.viewContext)
    @State private var selectedCategory: String = NSLocalizedString("selectedCategoryPrivate", comment: "Initial selected category")
    @State private var filter: String = NSLocalizedString("filterByDateAndPriority", comment: "Initial filter")
    @State private var isPresentingAddView = false
    @State private var isPickerPresented = false
    @State private var isPresentingSearchView = false
    @State private var isPresentingInfoView = false
    @State private var isShowingDeleteAlert = false
    @State private var deleteIndexSet: IndexSet?

    var body: some View {
        NavigationView {
            VStack {
                Picker(NSLocalizedString("category", comment: "Picker label"), selection: $selectedCategory) {
                    ForEach(viewModel.categories, id: \.originalName) { category in
                        Text(category.name).tag(category.originalName)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(viewModel.categories.first(where: { $0.originalName == selectedCategory })?.color ?? Color.clear)
                .cornerRadius(8)
                .padding()

                List {
                    ForEach(viewModel.filteredTasks(for: selectedCategory, filter: filter)) { dyt in
                        NavigationLink(destination: DoYourThingDetailView(dyt: dyt, viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "circle.hexagongrid.circle")
                                    .foregroundColor(viewModel.priorityColor(priority: dyt.dytPriority))
                                    .font(.system(size: 25))
                                Text(dyt.dytTitel)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: { indexSet in
                        deleteIndexSet = indexSet
                        isShowingDeleteAlert = true
                    })
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Button(action: {
                        isPresentingAddView = true
                    }) {
                        Image(systemName: "plus.rectangle.on.rectangle")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $isPresentingAddView) {
                        DoYourThingAddView(viewModel: viewModel)
                    }
                    Button(action: {
                        isPresentingSearchView = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $isPresentingSearchView) {
                        DoYourThingSearchView(viewModel: viewModel)
                    }
                },
                trailing: HStack {
                    Button(action: {
                        isPresentingInfoView = true
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                    .sheet(isPresented: $isPresentingInfoView) {
                        DoYourThingPriorityInformationView()
                    }
                    Button(action: {
                        isPickerPresented = true
                    }) {
                        Image(systemName: "blinds.horizontal.open")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                    .actionSheet(isPresented: $isPickerPresented) {
                        ActionSheet(
                            title: Text(NSLocalizedString("filter", comment: "Filter")),
                            message: Text(NSLocalizedString("choose_filter_option", comment: "Choose a filter option")),
                            buttons: [
                                .default(Text(NSLocalizedString("by_date_and_priority", comment: "By Date and Priority"))) {
                                    filter = NSLocalizedString("by_date_and_priority", comment: "By Date and Priority")
                                    viewModel.fetchDYT()
                                },
                                .default(Text(NSLocalizedString("by_priority_and_date", comment: "By Priority and Date"))) {
                                    filter = NSLocalizedString("by_priority_and_date", comment: "By Priority and Date")
                                    viewModel.fetchDYT()
                                },
                                .default(Text(NSLocalizedString("by_reminder", comment: "By Reminder"))) {
                                    filter = NSLocalizedString("by_reminder", comment: "By Reminder")
                                    viewModel.fetchDYT()
                                },
                                .default(Text(NSLocalizedString("by_deadline", comment: "By Deadline"))) {
                                    filter = NSLocalizedString("by_deadline", comment: "By Deadline")
                                    viewModel.fetchDYT()
                                },
                                .default(Text(NSLocalizedString("overdue_tasks", comment: "Overdue Tasks"))) {
                                    filter = NSLocalizedString("overdue_tasks", comment: "Overdue Tasks")
                                    viewModel.fetchDYT()
                                },
                                .cancel()
                            ]
                        )
                    }
                    NavigationLink(destination: DoYourThingSettingView(viewModel: viewModel)) {
                        Image(systemName: "gear")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                }
            )
            .onAppear {
                viewModel.fetchDYT()
                if let defaultCategory = viewModel.categories.first {
                    selectedCategory = defaultCategory.originalName
                }
            }
            .alert(isPresented: $isShowingDeleteAlert) {
                Alert(
                    title: Text(NSLocalizedString("deleteTaskTitle", comment: "Delete Task")),
                    message: Text(NSLocalizedString("deleteTaskMessage", comment: "Are you sure you want to delete this task?")),
                    primaryButton: .destructive(Text(NSLocalizedString("deleteButton", comment: "Delete"))) {
                        if let indexSet = deleteIndexSet, let index = indexSet.first {
                            let task = viewModel.filteredTasks(for: selectedCategory, filter: filter)[index]
                            viewModel.deleteDYT(task: task)
                            deleteIndexSet = nil
                        }
                    },
                    secondaryButton: .cancel(Text(NSLocalizedString("cancelButton", comment: "Cancel")))
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(viewModel.theme == "Light" ? .light : .dark)
    }
}

#Preview {
    ContentView()
}

