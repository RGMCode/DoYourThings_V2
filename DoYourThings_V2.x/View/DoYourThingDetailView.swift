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
            
            Text("Titel: \(dyt.dytTitel)")
                .font(.largeTitle)
                .padding()
            
            Text(dyt.dytDetailtext)
                .padding()
            
            Spacer()
            
            HStack {
                Spacer()
                Button(action: {
                    isPresentingEditView = true
                }) {
                    HStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 40))
                            .foregroundColor(.teal)
                        Text("Bearbeiten")
                            .font(.system(size: 30))
                            .foregroundColor(.teal)
                    }
                }
                Spacer()
            }
            .padding()
            .sheet(isPresented: $isPresentingEditView) {
                DoYourThingEditView(viewModel: viewModel, task: dyt)
            }
        }
        .navigationBarTitle("Aufgabendetails", displayMode: .inline)
        .onAppear {
            viewModel.fetchDYT()
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
