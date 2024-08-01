//
//  DoYourThingSearchView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

/*import SwiftUI

struct DoYourThingSearchView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var searchText: String = ""
    @State private var selectedTask: DoYourThing?

    var body: some View {
        VStack {
            TextField("Suche...", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { oldValue, newValue in
                    viewModel.searchTasks(query: newValue)
                }

            List(viewModel.searchResults) { task in
                Button(action: {
                    selectedTask = task
                }) {
                    HStack {
                        Image(systemName: "circle.hexagongrid.circle")
                            .foregroundColor(viewModel.priorityColor(priority: task.dytPriority))
                            .font(.system(size: 25))
                        Text(task.dytTitel)
                        Spacer()
                        VStack {
                            Text(task.dytDate, formatter: dateFormatter)
                            Text(task.dytTime, formatter: timeFormatter)
                        }
                        Image(systemName: "square.fill")
                            .foregroundColor(viewModel.getCategoryColor(for: task.dytCategory))
                            .font(.system(size: 20))
                    }
                }
            }
            .sheet(item: $selectedTask) { task in
                DoYourThingDetailView(dyt: task, viewModel: viewModel)
                    .onDisappear {
                        viewModel.searchTasks(query: searchText)
                    }
            }
        }
        .onAppear {
            viewModel.searchTasks(query: searchText)
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
    DoYourThingSearchView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
*/


import SwiftUI

struct DoYourThingSearchView: View {
    @ObservedObject var viewModel: DoYourThingViewModel
    @State private var searchText: String = ""
    @State private var selectedTask: DoYourThing?

    var body: some View {
        VStack {
            TextField(NSLocalizedString("searchPlaceholder", comment: "Search..."), text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText) { oldValue, newValue in
                    viewModel.searchTasks(query: newValue)
                }

            List(viewModel.searchResults) { task in
                Button(action: {
                    selectedTask = task
                }) {
                    HStack {
                        Image(systemName: "circle.hexagongrid.circle")
                            .foregroundColor(viewModel.priorityColor(priority: task.dytPriority))
                            .font(.system(size: 25))
                        Text(task.dytTitel)
                        Spacer()
                        VStack {
                            Text(task.dytDate, formatter: dateFormatter)
                            Text(task.dytTime, formatter: timeFormatter)
                        }
                        Image(systemName: "square.fill")
                            .foregroundColor(viewModel.getCategoryColor(for: task.dytCategory))
                            .font(.system(size: 20))
                    }
                }
            }
            .sheet(item: $selectedTask) { task in
                DoYourThingDetailView(dyt: task, viewModel: viewModel)
                    .onDisappear {
                        viewModel.searchTasks(query: searchText)
                    }
            }
        }
        .onAppear {
            viewModel.searchTasks(query: searchText)
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
    DoYourThingSearchView(viewModel: DoYourThingViewModel(context: PersistenceController.shared.container.viewContext))
}
