//
//  DoYourThingViewModel.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

/*import Foundation
import CoreData
import Combine
import SwiftUI

class DoYourThingViewModel: ObservableObject {
    @Published var dyts: [DoYourThing] = []
    @Published var searchResults: [DoYourThing] = []
    @Published var categories: [Category] = [
        Category(name: "Privat", color: .teal),
        Category(name: "Arbeit", color: .indigo)
    ]
    @Published var theme: String = "Light"
    @Published var themeIconColor: Color = .teal
    @Published var selectedTaskId: String?

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
                            dytDate: task.dytDate ?? Date(),
                            dytAlarmReminderDate: task.dytAlarmReminderDate ?? Date(),
                            dytAlarmReminderTime: task.dytAlarmReminderTime ?? Date(),
                            dytAlarmDeadlineDate: task.dytAlarmDeadlineDate ?? Date(),
                            dytAlarmDeadlineTime: task.dytAlarmDeadlineTime ?? Date())
            }
            self.searchResults = self.dyts
            print("Fetched \(self.dyts.count) tasks")
        } catch {
            print("Fehler beim Abrufen der Aufgaben: \(error)")
        }
    }

    func addDYT(title: String, detail: String, priority: String, category: String, date: Date, time: Date, alarmReminderDate: Date, alarmReminderTime: Date, alarmDeadlineDate: Date, alarmDeadlineTime: Date) {
        let newTask = DYT_DB(context: context)
        newTask.id = UUID()
        newTask.dytTitel = title
        newTask.dytDetailtext = detail
        newTask.dytPriority = priority
        newTask.dytCategory = category
        newTask.dytDate = date
        newTask.dytTime = time
        newTask.dytAlarmReminderDate = alarmReminderDate
        newTask.dytAlarmReminderTime = alarmReminderTime
        newTask.dytAlarmDeadlineDate = alarmDeadlineDate
        newTask.dytAlarmDeadlineTime = alarmDeadlineTime
        
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
                taskToUpdate.dytAlarmReminderDate = task.dytAlarmReminderDate
                taskToUpdate.dytAlarmReminderTime = task.dytAlarmReminderTime
                taskToUpdate.dytAlarmDeadlineDate = task.dytAlarmDeadlineDate
                taskToUpdate.dytAlarmDeadlineTime = task.dytAlarmDeadlineTime
                
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
        if (!categories.contains { $0.name == name }) {
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
        print("Kategorie wird gelöscht: \(name)")
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
                print("Kategorie und zugehörige Aufgaben gelöscht: \(name)")
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
        case "Erinnerung":
            tasks.sort {
                $0.dytAlarmReminderDate < $1.dytAlarmReminderDate || ($0.dytAlarmReminderDate == $1.dytAlarmReminderDate && $0.dytAlarmReminderTime < $1.dytAlarmReminderTime)
            }
        case "Deadline":
            tasks.sort {
                $0.dytAlarmDeadlineDate < $1.dytAlarmDeadlineDate || ($0.dytAlarmDeadlineDate == $1.dytAlarmDeadlineDate && $0.dytAlarmDeadlineTime < $1.dytAlarmDeadlineTime)
            }
        case "Abgelaufen":
            let now = Date()
            tasks.sort {
                let isOverdue0 = $0.dytAlarmReminderDate < now || $0.dytAlarmDeadlineDate < now
                let isOverdue1 = $1.dytAlarmReminderDate < now || $1.dytAlarmDeadlineDate < now
                return isOverdue0 && !isOverdue1
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

extension DoYourThingViewModel {
    func getCategoryColor(for categoryName: String) -> Color {
        return categories.first { $0.name == categoryName }?.color ?? .clear
    }
}*/


/*import Foundation
import CoreData
import Combine
import SwiftUI

class DoYourThingViewModel: ObservableObject {
    @Published var dyts: [DoYourThing] = []
    @Published var searchResults: [DoYourThing] = []
    @Published var categories: [Category] = [
        Category(name: NSLocalizedString("privateCategory", comment: "Private category"), color: .teal),
        Category(name: NSLocalizedString("workCategory", comment: "Work category"), color: .indigo)
    ]
    @Published var theme: String = "Light"
    @Published var themeIconColor: Color = .teal
    @Published var selectedTaskId: String?

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
                            dytDate: task.dytDate ?? Date(),
                            dytAlarmReminderDate: task.dytAlarmReminderDate ?? Date(),
                            dytAlarmReminderTime: task.dytAlarmReminderTime ?? Date(),
                            dytAlarmDeadlineDate: task.dytAlarmDeadlineDate ?? Date(),
                            dytAlarmDeadlineTime: task.dytAlarmDeadlineTime ?? Date())
            }
            self.searchResults = self.dyts
            print("Fetched \(self.dyts.count) tasks")
        } catch {
            print("Fehler beim Abrufen der Aufgaben: \(error)")
        }
    }

    func addDYT(title: String, detail: String, priority: String, category: String, date: Date, time: Date, alarmReminderDate: Date, alarmReminderTime: Date, alarmDeadlineDate: Date, alarmDeadlineTime: Date) {
        let newTask = DYT_DB(context: context)
        newTask.id = UUID()
        newTask.dytTitel = title
        newTask.dytDetailtext = detail
        newTask.dytPriority = priority
        newTask.dytCategory = category
        newTask.dytDate = date
        newTask.dytTime = time
        newTask.dytAlarmReminderDate = alarmReminderDate
        newTask.dytAlarmReminderTime = alarmReminderTime
        newTask.dytAlarmDeadlineDate = alarmDeadlineDate
        newTask.dytAlarmDeadlineTime = alarmDeadlineTime
        
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
                taskToUpdate.dytAlarmReminderDate = task.dytAlarmReminderDate
                taskToUpdate.dytAlarmReminderTime = task.dytAlarmReminderTime
                taskToUpdate.dytAlarmDeadlineDate = task.dytAlarmDeadlineDate
                taskToUpdate.dytAlarmDeadlineTime = task.dytAlarmDeadlineTime
                
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
        if (!categories.contains { $0.name == name }) {
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
        print("Kategorie wird gelöscht: \(name)")
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
                print("Kategorie und zugehörige Aufgaben gelöscht: \(name)")
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
        case NSLocalizedString("by_date_and_priority", comment: "By Date and Priority"):
            tasks.sort {
                if $0.dytDate != $1.dytDate {
                    return $0.dytDate > $1.dytDate
                } else {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                }
            }
        case NSLocalizedString("by_priority_and_date", comment: "By Priority and Date"):
            tasks.sort {
                if priorityRank($0.dytPriority) != priorityRank($1.dytPriority) {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                } else {
                    return $0.dytDate > $1.dytDate
                }
            }
        case NSLocalizedString("by_reminder", comment: "By Reminder"):
            tasks.sort {
                $0.dytAlarmReminderDate < $1.dytAlarmReminderDate || ($0.dytAlarmReminderDate == $1.dytAlarmReminderDate && $0.dytAlarmReminderTime < $1.dytAlarmReminderTime)
            }
        case NSLocalizedString("by_deadline", comment: "By Deadline"):
            tasks.sort {
                $0.dytAlarmDeadlineDate < $1.dytAlarmDeadlineDate || ($0.dytAlarmDeadlineDate == $1.dytAlarmDeadlineDate && $0.dytAlarmDeadlineTime < $1.dytAlarmDeadlineTime)
            }
        case NSLocalizedString("overdue_tasks", comment: "Overdue Tasks"):
            let now = Date()
            tasks.sort {
                let isOverdue0 = $0.dytAlarmReminderDate < now || $0.dytAlarmDeadlineDate < now
                let isOverdue1 = $1.dytAlarmReminderDate < now || $1.dytAlarmDeadlineDate < now
                return isOverdue0 && !isOverdue1
            }
        default:
            break
        }
        return tasks
    }

    func priorityRank(_ priority: String) -> Int {
        let localizedPriority = localizedPriorityString(priority)
        switch localizedPriority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return 5
        case NSLocalizedString("high", comment: "High"):
            return 4
        case NSLocalizedString("medium", comment: "Medium"):
            return 3
        case NSLocalizedString("low", comment: "Low"):
            return 2
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return 1
        default:
            return 0
        }
    }

    func priorityColor(priority: String) -> Color {
        let localizedPriority = localizedPriorityString(priority)
        switch localizedPriority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return .red
        case NSLocalizedString("high", comment: "High"):
            return .orange
        case NSLocalizedString("medium", comment: "Medium"):
            return .yellow
        case NSLocalizedString("low", comment: "Low"):
            return .green
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return .blue
        default:
            return .gray
        }
    }

    private func localizedPriorityString(_ priority: String) -> String {
        switch priority {
        case "Sehr Hoch":
            return NSLocalizedString("veryHigh", comment: "Very High")
        case "Hoch":
            return NSLocalizedString("high", comment: "High")
        case "Mittel":
            return NSLocalizedString("medium", comment: "Medium")
        case "Niedrig":
            return NSLocalizedString("low", comment: "Low")
        case "Sehr Niedrig":
            return NSLocalizedString("veryLow", comment: "Very Low")
        default:
            return priority
        }
    }


}

extension DoYourThingViewModel {
    func getCategoryColor(for categoryName: String) -> Color {
        return categories.first { $0.name == categoryName }?.color ?? .clear
    }
}
*/

/*import Foundation
import CoreData
import Combine
import SwiftUI

class DoYourThingViewModel: ObservableObject {
    @Published var dyts: [DoYourThing] = []
    @Published var searchResults: [DoYourThing] = []
    @Published var categories: [Category] = [
        Category(originalName: "privateCategory", color: .teal),
        Category(originalName: "workCategory", color: .indigo)
    ]
    @Published var theme: String = "Light"
    @Published var themeIconColor: Color = .teal
    @Published var selectedTaskId: String?

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
                            dytDate: task.dytDate ?? Date(),
                            dytAlarmReminderDate: task.dytAlarmReminderDate ?? Date(),
                            dytAlarmReminderTime: task.dytAlarmReminderTime ?? Date(),
                            dytAlarmDeadlineDate: task.dytAlarmDeadlineDate ?? Date(),
                            dytAlarmDeadlineTime: task.dytAlarmDeadlineTime ?? Date())
            }
            self.searchResults = self.dyts
            print("Fetched \(self.dyts.count) tasks")
        } catch {
            print("Fehler beim Abrufen der Aufgaben: \(error)")
        }
    }

    func addDYT(title: String, detail: String, priority: String, category: String, date: Date, time: Date, alarmReminderDate: Date, alarmReminderTime: Date, alarmDeadlineDate: Date, alarmDeadlineTime: Date) {
        let newTask = DYT_DB(context: context)
        newTask.id = UUID()
        newTask.dytTitel = title
        newTask.dytDetailtext = detail
        newTask.dytPriority = priority
        newTask.dytCategory = category
        newTask.dytDate = date
        newTask.dytTime = time
        newTask.dytAlarmReminderDate = alarmReminderDate
        newTask.dytAlarmReminderTime = alarmReminderTime
        newTask.dytAlarmDeadlineDate = alarmDeadlineDate
        newTask.dytAlarmDeadlineTime = alarmDeadlineTime
        
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
                taskToUpdate.dytAlarmReminderDate = task.dytAlarmReminderDate
                taskToUpdate.dytAlarmReminderTime = task.dytAlarmReminderTime
                taskToUpdate.dytAlarmDeadlineDate = task.dytAlarmDeadlineDate
                taskToUpdate.dytAlarmDeadlineTime = task.dytAlarmDeadlineTime
                
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
        if !categories.contains(where: { $0.originalName == name }) {
            categories.append(Category(originalName: name, color: color))
        }
    }

    func updateCategory(oldName: String, newName: String, color: Color) {
        if let index = categories.firstIndex(where: { $0.originalName == oldName }) {
            categories[index] = Category(originalName: newName, color: color)
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
        print("Kategorie wird gelöscht: \(name)")
        if let index = categories.firstIndex(where: { $0.originalName == name }) {
            categories.remove(at: index)
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", name)
            do {
                let results = try context.fetch(request)
                for task in results {
                    context.delete(task)
                }
                try context.save()
                print("Kategorie und zugehörige Aufgaben gelöscht: \(name)")
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
        case NSLocalizedString("by_date_and_priority", comment: "By Date and Priority"):
            tasks.sort {
                if $0.dytDate != $1.dytDate {
                    return $0.dytDate > $1.dytDate
                } else {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                }
            }
        case NSLocalizedString("by_priority_and_date", comment: "By Priority and Date"):
            tasks.sort {
                if priorityRank($0.dytPriority) != priorityRank($1.dytPriority) {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                } else {
                    return $0.dytDate > $1.dytDate
                }
            }
        case NSLocalizedString("by_reminder", comment: "By Reminder"):
            tasks.sort {
                $0.dytAlarmReminderDate < $1.dytAlarmReminderDate || ($0.dytAlarmReminderDate == $1.dytAlarmReminderDate && $0.dytAlarmReminderTime < $1.dytAlarmReminderTime)
            }
        case NSLocalizedString("by_deadline", comment: "By Deadline"):
            tasks.sort {
                $0.dytAlarmDeadlineDate < $1.dytAlarmDeadlineDate || ($0.dytAlarmDeadlineDate == $1.dytAlarmDeadlineDate && $0.dytAlarmDeadlineTime < $1.dytAlarmDeadlineTime)
            }
        case NSLocalizedString("overdue_tasks", comment: "Overdue Tasks"):
            let now = Date()
            tasks.sort {
                let isOverdue0 = $0.dytAlarmReminderDate < now || $0.dytAlarmDeadlineDate < now
                let isOverdue1 = $1.dytAlarmReminderDate < now || $1.dytAlarmDeadlineDate < now
                return isOverdue0 && !isOverdue1
            }
        default:
            break
        }
        return tasks
    }

    func priorityRank(_ priority: String) -> Int {
        switch priority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return 5
        case NSLocalizedString("high", comment: "High"):
            return 4
        case NSLocalizedString("medium", comment: "Medium"):
            return 3
        case NSLocalizedString("low", comment: "Low"):
            return 2
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return 1
        default:
            return 0
        }
    }

    func priorityColor(priority: String) -> Color {
        switch priority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return .red
        case NSLocalizedString("high", comment: "High"):
            return .orange
        case NSLocalizedString("medium", comment: "Medium"):
            return .yellow
        case NSLocalizedString("low", comment: "Low"):
            return .green
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return .blue
        default:
            return .gray
        }
    }
}

extension DoYourThingViewModel {
    func getCategoryColor(for categoryName: String) -> Color {
        return categories.first { $0.originalName == categoryName }?.color ?? .clear
    }
}
*/


/*import Foundation
import CoreData
import Combine
import SwiftUI

class DoYourThingViewModel: ObservableObject {
    @Published var dyts: [DoYourThing] = []
    @Published var searchResults: [DoYourThing] = []
    @Published var categories: [Category] = [
        Category(originalName: "privateCategory", color: .teal),
        Category(originalName: "workCategory", color: .indigo)
    ]
    @Published var theme: String = "Light"
    @Published var themeIconColor: Color = .teal
    @Published var selectedTaskId: String?

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
                            dytDate: task.dytDate ?? Date(),
                            dytAlarmReminderDate: task.dytAlarmReminderDate ?? Date(),
                            dytAlarmReminderTime: task.dytAlarmReminderTime ?? Date(),
                            dytAlarmDeadlineDate: task.dytAlarmDeadlineDate ?? Date(),
                            dytAlarmDeadlineTime: task.dytAlarmDeadlineTime ?? Date())
            }
            self.searchResults = self.dyts
            print("Fetched \(self.dyts.count) tasks")
        } catch {
            print("Fehler beim Abrufen der Aufgaben: \(error)")
        }
    }

    func addDYT(title: String, detail: String, priority: String, category: String, date: Date, time: Date, alarmReminderDate: Date, alarmReminderTime: Date, alarmDeadlineDate: Date, alarmDeadlineTime: Date) {
        let newTask = DYT_DB(context: context)
        newTask.id = UUID()
        newTask.dytTitel = title
        newTask.dytDetailtext = detail
        newTask.dytPriority = priority
        newTask.dytCategory = category
        newTask.dytDate = date
        newTask.dytTime = time
        newTask.dytAlarmReminderDate = alarmReminderDate
        newTask.dytAlarmReminderTime = alarmReminderTime
        newTask.dytAlarmDeadlineDate = alarmDeadlineDate
        newTask.dytAlarmDeadlineTime = alarmDeadlineTime
        
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
                taskToUpdate.dytAlarmReminderDate = task.dytAlarmReminderDate
                taskToUpdate.dytAlarmReminderTime = task.dytAlarmReminderTime
                taskToUpdate.dytAlarmDeadlineDate = task.dytAlarmDeadlineDate
                taskToUpdate.dytAlarmDeadlineTime = task.dytAlarmDeadlineTime
                
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

    func addCategory(name: String, originalName: String, color: Color) {
        if !categories.contains(where: { $0.originalName == originalName }) {
            var newCategory = Category(originalName: originalName, color: color)
            newCategory.name = name // Save the custom name if provided
            categories.append(newCategory)
        }
    }

    func updateCategory(oldName: String, newName: String, color: Color) {
        if let index = categories.firstIndex(where: { $0.originalName == oldName }) {
            categories[index] = Category(originalName: oldName, color: color)
            categories[index].name = newName
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
        print("Kategorie wird gelöscht: \(name)")
        if let index = categories.firstIndex(where: { $0.originalName == name }) {
            categories.remove(at: index)
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", name)
            do {
                let results = try context.fetch(request)
                for task in results {
                    context.delete(task)
                }
                try context.save()
                print("Kategorie und zugehörige Aufgaben gelöscht: \(name)")
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
        case NSLocalizedString("by_date_and_priority", comment: "By Date and Priority"):
            tasks.sort {
                if $0.dytDate != $1.dytDate {
                    return $0.dytDate > $1.dytDate
                } else {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                }
            }
        case NSLocalizedString("by_priority_and_date", comment: "By Priority and Date"):
            tasks.sort {
                if priorityRank($0.dytPriority) != priorityRank($1.dytPriority) {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                } else {
                    return $0.dytDate > $1.dytDate
                }
            }
        case NSLocalizedString("by_reminder", comment: "By Reminder"):
            tasks.sort {
                $0.dytAlarmReminderDate < $1.dytAlarmReminderDate || ($0.dytAlarmReminderDate == $1.dytAlarmReminderDate && $0.dytAlarmReminderTime < $1.dytAlarmReminderTime)
            }
        case NSLocalizedString("by_deadline", comment: "By Deadline"):
            tasks.sort {
                $0.dytAlarmDeadlineDate < $1.dytAlarmDeadlineDate || ($0.dytAlarmDeadlineDate == $1.dytAlarmDeadlineDate && $0.dytAlarmDeadlineTime < $1.dytAlarmDeadlineTime)
            }
        case NSLocalizedString("overdue_tasks", comment: "Overdue Tasks"):
            let now = Date()
            tasks.sort {
                let isOverdue0 = $0.dytAlarmReminderDate < now || $0.dytAlarmDeadlineDate < now
                let isOverdue1 = $1.dytAlarmReminderDate < now || $1.dytAlarmDeadlineDate < now
                return isOverdue0 && !isOverdue1
            }
        default:
            break
        }
        return tasks
    }

    func priorityRank(_ priority: String) -> Int {
        switch priority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return 5
        case NSLocalizedString("high", comment: "High"):
            return 4
        case NSLocalizedString("medium", comment: "Medium"):
            return 3
        case NSLocalizedString("low", comment: "Low"):
            return 2
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return 1
        default:
            return 0
        }
    }

    func priorityColor(priority: String) -> Color {
        switch priority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return .red
        case NSLocalizedString("high", comment: "High"):
            return .orange
        case NSLocalizedString("medium", comment: "Medium"):
            return .yellow
        case NSLocalizedString("low", comment: "Low"):
            return .green
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return .blue
        default:
            return .gray
        }
    }
}

extension DoYourThingViewModel {
    func getCategoryColor(for categoryName: String) -> Color {
        return categories.first { $0.originalName == categoryName }?.color ?? .clear
    }
}
*/

import Foundation
import CoreData
import Combine
import SwiftUI

class DoYourThingViewModel: ObservableObject {
    static let shared = DoYourThingViewModel(context: PersistenceController.shared.container.viewContext)
    
    @Published var dyts: [DoYourThing] = []
    @Published var searchResults: [DoYourThing] = []
    @Published var categories: [Category] = [
        Category(originalName: "privateCategory", color: .teal),
        Category(originalName: "workCategory", color: .indigo)
    ]
    @Published var theme: String = "Light"
    @Published var themeIconColor: Color = .teal
    @Published var selectedTaskId: String?

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
                            dytDate: task.dytDate ?? Date(),
                            dytAlarmReminderDate: task.dytAlarmReminderDate ?? Date(),
                            dytAlarmReminderTime: task.dytAlarmReminderTime ?? Date(),
                            dytAlarmDeadlineDate: task.dytAlarmDeadlineDate ?? Date(),
                            dytAlarmDeadlineTime: task.dytAlarmDeadlineTime ?? Date())
            }
            self.searchResults = self.dyts
            print("Fetched \(self.dyts.count) tasks")
        } catch {
            print("Fehler beim Abrufen der Aufgaben: \(error)")
        }
    }

    func addDYT(title: String, detail: String, priority: String, category: String, date: Date, time: Date, alarmReminderDate: Date, alarmReminderTime: Date, alarmDeadlineDate: Date, alarmDeadlineTime: Date) {
        let newTask = DYT_DB(context: context)
        newTask.id = UUID()
        newTask.dytTitel = title
        newTask.dytDetailtext = detail
        newTask.dytPriority = priority
        newTask.dytCategory = category
        newTask.dytDate = date
        newTask.dytTime = time
        newTask.dytAlarmReminderDate = alarmReminderDate
        newTask.dytAlarmReminderTime = alarmReminderTime
        newTask.dytAlarmDeadlineDate = alarmDeadlineDate
        newTask.dytAlarmDeadlineTime = alarmDeadlineTime
        
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
                taskToUpdate.dytAlarmReminderDate = task.dytAlarmReminderDate
                taskToUpdate.dytAlarmReminderTime = task.dytAlarmReminderTime
                taskToUpdate.dytAlarmDeadlineDate = task.dytAlarmDeadlineDate
                taskToUpdate.dytAlarmDeadlineTime = task.dytAlarmDeadlineTime
                
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
        if !categories.contains(where: { $0.originalName == name }) {
            categories.append(Category(originalName: name, color: color))
        }
    }

    func updateCategory(oldName: String, newName: String, color: Color) {
        if let index = categories.firstIndex(where: { $0.originalName == oldName }) {
            categories[index] = Category(originalName: newName, color: color)
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
        print("Kategorie wird gelöscht: \(name)")
        if let index = categories.firstIndex(where: { $0.originalName == name }) {
            categories.remove(at: index)
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", name)
            do {
                let results = try context.fetch(request)
                for task in results {
                    context.delete(task)
                }
                try context.save()
                print("Kategorie und zugehörige Aufgaben gelöscht: \(name)")
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
        case NSLocalizedString("by_date_and_priority", comment: "By Date and Priority"):
            tasks.sort {
                if $0.dytDate != $1.dytDate {
                    return $0.dytDate > $1.dytDate
                } else {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                }
            }
        case NSLocalizedString("by_priority_and_date", comment: "By Priority and Date"):
            tasks.sort {
                if priorityRank($0.dytPriority) != priorityRank($1.dytPriority) {
                    return priorityRank($0.dytPriority) > priorityRank($1.dytPriority)
                } else {
                    return $0.dytDate > $1.dytDate
                }
            }
        case NSLocalizedString("by_reminder", comment: "By Reminder"):
            tasks.sort {
                $0.dytAlarmReminderDate < $1.dytAlarmReminderDate || ($0.dytAlarmReminderDate == $1.dytAlarmReminderDate && $0.dytAlarmReminderTime < $1.dytAlarmReminderTime)
            }
        case NSLocalizedString("by_deadline", comment: "By Deadline"):
            tasks.sort {
                $0.dytAlarmDeadlineDate < $1.dytAlarmDeadlineDate || ($0.dytAlarmDeadlineDate == $1.dytAlarmDeadlineDate && $0.dytAlarmDeadlineTime < $1.dytAlarmDeadlineTime)
            }
        case NSLocalizedString("overdue_tasks", comment: "Overdue Tasks"):
            let now = Date()
            tasks.sort {
                let isOverdue0 = $0.dytAlarmReminderDate < now || $0.dytAlarmDeadlineDate < now
                let isOverdue1 = $1.dytAlarmReminderDate < now || $1.dytAlarmDeadlineDate < now
                return isOverdue0 && !isOverdue1
            }
        default:
            break
        }
        return tasks
    }

    func priorityRank(_ priority: String) -> Int {
        switch priority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return 5
        case NSLocalizedString("high", comment: "High"):
            return 4
        case NSLocalizedString("medium", comment: "Medium"):
            return 3
        case NSLocalizedString("low", comment: "Low"):
            return 2
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return 1
        default:
            return 0
        }
    }

    func priorityColor(priority: String) -> Color {
        switch priority {
        case NSLocalizedString("veryHigh", comment: "Very High"):
            return .red
        case NSLocalizedString("high", comment: "High"):
            return .orange
        case NSLocalizedString("medium", comment: "Medium"):
            return .yellow
        case NSLocalizedString("low", comment: "Low"):
            return .green
        case NSLocalizedString("veryLow", comment: "Very Low"):
            return .blue
        default:
            return .gray
        }
    }
}

extension DoYourThingViewModel {
    func getCategoryColor(for categoryName: String) -> Color {
        return categories.first { $0.originalName == categoryName }?.color ?? .clear
    }
}

