//
//  DoYourThingSearchView.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 14.07.24.
//

import SwiftUI

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
                .onChange(of: searchText) { newValue in
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


}
