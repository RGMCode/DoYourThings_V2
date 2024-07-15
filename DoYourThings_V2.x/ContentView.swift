//
//  ContentView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DoYourThingViewModel(context: PersistenceController.shared.container.viewContext)
    @State private var selectedCategory: String = "Privat"
    @State private var filter: String = "Datum und Priorität"
    @State private var isPresentingAddView = false
    @State private var isPickerPresented = false
    @State private var isPresentingSearchView = false
    @State private var isPresentingInfoView = false

    var body: some View {
        NavigationView {
            VStack {
                Picker("Kategorie", selection: $selectedCategory) {
                    ForEach(viewModel.categories, id: \.name) { category in
                        Text(category.name).tag(category.name)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(viewModel.categories.first(where: { $0.name == selectedCategory })?.color ?? Color.clear)
                .cornerRadius(8)
                .padding()

                List {
                    ForEach(filteredTasks()) { dyt in
                        NavigationLink(destination: DoYourThingDetailView(dyt: dyt, viewModel: viewModel)) {
                            HStack {
                                Image(systemName: "circle.hexagongrid.circle")
                                    .foregroundColor(priorityColor(priority: dyt.dytPriority))
                                    .font(.system(size: 25))
                                Text(dyt.dytTitel)
                                Spacer()
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Button(action: {
                        isPresentingAddView = true
                    }) {
                        Image(systemName: "note.text.badge.plus")
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
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                    .actionSheet(isPresented: $isPickerPresented) {
                        ActionSheet(
                            title: Text("Filter"),
                            message: Text("Wählen Sie eine Filteroption"),
                            buttons: [
                                .default(Text("Nach Datum und Priorität")) {
                                    filter = "Datum und Priorität"
                                    viewModel.fetchDYT()
                                },
                                .default(Text("Nach Priorität und Datum")) {
                                    filter = "Priorität und Datum"
                                    viewModel.fetchDYT()
                                },
                                .cancel()
                            ]
                        )
                    }
                    NavigationLink(destination: DoYourThingSettingView(viewModel: viewModel)) {
                        Image(systemName: "gear.circle.fill")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                }
            )
            .onAppear {
                viewModel.fetchDYT()
            }
        }
        .preferredColorScheme(viewModel.theme == "Light" ? .light : .dark)
    
    }
    
    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let task = viewModel.dyts[index]
            viewModel.deleteDYT(task: task)
        }
    }

    func filteredTasks() -> [DoYourThing] {
        var tasks = viewModel.dyts.filter { $0.dytCategory == selectedCategory }
        switch filter {
        case "Datum und Priorität":
            tasks.sort {
                if $0.dytDate != $1.dytDate {
                    return $0.dytDate > $1.dytDate
                } else {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                }
            }
        case "Priorität und Datum":
            tasks.sort {
                if priorityRank($0.dytPriority) != priorityRank($1.dytPriority) {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                } else {
                    return $0.dytDate > $1.dytDate
                }
            }
        default:
            break
        }
        return tasks
    }
    
    func priorityRank(_ priority: String) -> Int {
        switch priority {
        case "Sehr Hoch":
            return 5
        case "Hoch":
            return 4
        case "Mittel":
            return 3
        case "Niedrig":
            return 2
        case "Sehr Niedrig":
            return 1
        default:
            return 0
        }
    }
    
    func priorityColor(priority: String) -> Color {
        switch priority {
        case "Sehr Hoch":
            return .red
        case "Hoch":
            return .orange
        case "Mittel":
            return .yellow
        case "Niedrig":
            return .green
        case "Sehr Niedrig":
            return .blue
        default:
            return .gray
        }
    }
}

#Preview {
    ContentView()
}
