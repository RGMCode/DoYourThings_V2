//
//  DoYourThingViewModel.swift
//  DoYourThings_V2.x
//
//  Created by RGMCode on 13.07.24.
//

import Foundation
import CoreData
import Combine

class DoYourThingViewModel: ObservableObject {
    @Published var dyts: [DoYourThing] = []
    @Published var categories: [String] = ["Privat", "Arbeit"]
    
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
        } catch {
            print("Error fetching tasks: \(error)")
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
            fetchDYT()
        } catch {
            print("Error saving new task: \(error)")
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
                fetchDYT()
            }
        } catch {
            print("Error deleting task: \(error)")
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
                fetchDYT()
            }
        } catch {
            print("Error updating task: \(error)")
        }
    }
    
    func addCategory(name: String) {
        if !categories.contains(name) {
            categories.append(name)
        }
    }
    
    func updateCategory(oldName: String, newName: String) {
        if let index = categories.firstIndex(of: oldName) {
            categories[index] = newName
            // Optionally update category name in all tasks
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", oldName)
            
            do {
                let results = try context.fetch(request)
                for task in results {
                    task.dytCategory = newName
                }
                try context.save()
                fetchDYT()
            } catch {
                print("Error updating tasks for category \(oldName): \(error)")
            }
        }
    }
    
    func deleteCategory(name: String) {
        if let index = categories.firstIndex(of: name) {
            categories.remove(at: index)
            // Optionally, you can also remove tasks under this category
            dyts.removeAll { $0.dytCategory == name }
            // To remove the tasks from Core Data as well
            let request: NSFetchRequest<DYT_DB> = DYT_DB.fetchRequest()
            request.predicate = NSPredicate(format: "dytCategory == %@", name)
            do {
                let results = try context.fetch(request)
                for task in results {
                    context.delete(task)
                }
                try context.save()
                fetchDYT()
            } catch {
                print("Error deleting tasks for category \(name): \(error)")
            }
        }
    }
}


