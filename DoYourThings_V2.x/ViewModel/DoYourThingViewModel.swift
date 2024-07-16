//
//  DoYourThingViewModel.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import Foundation
import CoreData
import Combine
import SwiftUI

class DoYourThingViewModel: ObservableObject {
    @Published var dyts: [DoYourThing] = []
    @Published var searchResults: [DoYourThing] = []
    @Published var categories: [Category] = [
        Category(name: "Privat", color: .blue),
        Category(name: "Arbeit", color: .green)
    ]
    @Published var theme: String = "Light"
    @Published var themeIconColor: Color = .blue
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchDYT()
    }
    
    func fetchDYT() {
        let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            self.dyts = results.map { task in
                DoYourThing(id: task.id ?? UUID(),
                            dytTitel: task.dytTitel ?? "",
                            dytDetailtext: task.dytDetailtext ?? "",
                            dytPriority: task.dytPriority ?? "",
                            dytCategory: task.dytCategory ?? "",
                            dytTime: task.dytTime ?? Date(),
                            dytDate: task.dytDate ?? Date())
            }
            self.searchResults = self.dyts
            print("Fetched \(self.dyts.count) tasks")
        } catch {
            print("Fehler beim Abrufen der Aufgaben: \(error)")
        }
    }
    
    func addDYT(title: String, detail: String, priority: String, category: String, date: Date, time: Date) {
        let newTask = DYT_DB(context: context)
        newTask.id = UUID()
        newTask.dytTitel = title
        newTask.dytDetailtext = detail
        newTask.dytPriority = priority
        newTask.dytCategory = category
        newTask.dytDate = date
        newTask.dytTime = time
        
        do {
            try context.save()
            print("Task hinzugefügt: \(newTask)")
            fetchDYT()
        } catch {
            print("Fehler beim Speichern der neuen Aufgabe: \(error)")
        }
    }
    
    func deleteDYT(task: DoYourThing) {
        let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let taskToDelete = results.first {
                context.delete(taskToDelete)
                try context.save()
                print("Task gelöscht: \(task)")
                fetchDYT()
            }
        } catch {
            print("Fehler beim Löschen der Aufgabe: \(error)")
        }
    }
    
    func updateDYT(task: DoYourThing) {
        let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let taskToUpdate = results.first {
                taskToUpdate.dytTitel = task.dytTitel
                taskToUpdate.dytDetailtext = task.dytDetailtext
                taskToUpdate.dytPriority = task.dytPriority
                taskToUpdate.dytCategory = task.dytCategory
                taskToUpdate.dytDate = task.dytDate
                taskToUpdate.dytTime = task.dytTime
                
                try context.save()
                print("Task aktualisiert: \(taskToUpdate)")
                fetchDYT()
            } else {
                print("Aufgabe nicht gefunden für id: \(task.id)")
            }
        } catch {
            print("Fehler beim Aktualisieren der Aufgabe: \(error)")
        }
    }
    
    func addCategory(name: String, color: Color) {
        if !categories.contains(where: { $0.name == name }) {
            categories.append(Category(name: name, color: color))
        }
    }
    
    func updateCategory(oldName: String, newName: String, color: Color) {
        if let index = categories.firstIndex(where: { $0.name == oldName }) {
            categories[index] = Category(name: newName, color: color)
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", oldName)
            
            do {
                let results = try context.fetch(request)
                for task in results {
                    task.dytCategory = newName
                }
                try context.save()
                print("Kategorie aktualisiert: \(oldName) zu \(newName)")
                fetchDYT()
            } catch {
                print("Fehler beim Aktualisieren der Aufgaben für Kategorie \(oldName): \(error)")
            }
        }
    }
    
    func deleteCategory(name: String) {
        print("Kategorie wird gelöscht: \(name)") // Debugging-Informationen
        if let index = categories.firstIndex(where: { $0.name == name }) {
            categories.remove(at: index)
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", name)
            do {
                let results = try context.fetch(request)
                for task in results {
                    context.delete(task)
                }
                try context.save()
                print("Kategorie und zugehörige Aufgaben gelöscht: \(name)") // Debugging-Informationen
                fetchDYT()
            } catch {
                print("Fehler beim Löschen der Aufgaben für Kategorie \(name): \(error)")
            }
        }
    }
    
    func searchTasks(query: String) {
        if query.isEmpty {
            searchResults = dyts
        } else {
            searchResults = dyts.filter { $0.dytTitel.localizedCaseInsensitiveContains(query) || $0.dytDetailtext.localizedCaseInsensitiveContains(query) }
        }
    }

    func filteredTasks(for category: String, filter: String) -> [DoYourThing] {
        var tasks = dyts.filter { $0.dytCategory == category }
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
