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
    @State private var isShowingDeleteAlert = false
    @State private var deleteIndexSet: IndexSet?

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
                        Image(systemName: "gear")
                            .foregroundColor(viewModel.themeIconColor)
                            .font(.system(size: 30))
                    }
                }
            )
            .onAppear {
                viewModel.fetchDYT()
            }
            .alert(isPresented: $isShowingDeleteAlert) {
                Alert(
                    title: Text("Aufgabe löschen"),
                    message: Text("Sind Sie sicher, dass Sie diese Aufgabe löschen möchten?"),
                    primaryButton: .destructive(Text("Löschen")) {
                        if let indexSet = deleteIndexSet, let index = indexSet.first {
                            let task = viewModel.filteredTasks(for: selectedCategory, filter: filter)[index]
                            viewModel.deleteDYT(task: task)
                            deleteIndexSet = nil
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .preferredColorScheme(viewModel.theme == "Light" ? .light : .dark)
    }
}

#Preview {
    ContentView()
}
