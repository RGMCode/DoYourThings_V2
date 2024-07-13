//
//  DoYourThingViewModelTests.swift
//  DoYourThings_V2.xTests
//
//  Created by RGMCode on 13.07.24.
//

import XCTest
import CoreData
@testable import DoYourThings_V2_x

class DoYourThingViewModelTests: XCTestCase {
    
    var viewModel: DoYourThingViewModel!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        context = setUpInMemoryManagedObjectContext()
        viewModel = DoYourThingViewModel(context: context)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        context = nil
    }
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DoYourThingModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { description, error in
            XCTAssertNil(error)
        }
        return container.viewContext
    }
    
    func testFetchDYT() {
        // Given
        let title = "Test Task"
        let detail = "Test Detail"
        let priority = "Mittel"
        let category = "Privat"
        let date = Date()
        let time = Date()
        
        viewModel.addDYT(title: title, detail: detail, priority: priority, category: category, date: date, time: time)
        
        // When
        viewModel.fetchDYT()
        
        // Then
        XCTAssertEqual(viewModel.dyts.count, 1)
        XCTAssertEqual(viewModel.dyts.first?.dytTitel, title)
        XCTAssertEqual(viewModel.dyts.first?.dytDetailtext, detail)
    }
    
    func testAddDYT() {
        // Given
        let title = "New Task"
        let detail = "New Detail"
        let priority = "Hoch"
        let category = "Arbeit"
        let date = Date()
        let time = Date()
        
        // When
        viewModel.addDYT(title: title, detail: detail, priority: priority, category: category, date: date, time: time)
        
        // Then
        XCTAssertEqual(viewModel.dyts.count, 1)
        XCTAssertEqual(viewModel.dyts.first?.dytTitel, title)
        XCTAssertEqual(viewModel.dyts.first?.dytDetailtext, detail)
    }
    
    func testDeleteDYT() {
        // Given
        let title = "Task to Delete"
        let detail = "Detail to Delete"
        let priority = "Mittel"
        let category = "Privat"
        let date = Date()
        let time = Date()
        
        viewModel.addDYT(title: title, detail: detail, priority: priority, category: category, date: date, time: time)
        let task = viewModel.dyts.first!
        
        // When
        viewModel.deleteDYT(task: task)
        
        // Then
        XCTAssertEqual(viewModel.dyts.count, 0)
    }
    
    func testUpdateDYT() {
        // Given
        let title = "Task to Update"
        let detail = "Detail to Update"
        let priority = "Mittel"
        let category = "Privat"
        let date = Date()
        let time = Date()
        
        viewModel.addDYT(title: title, detail: detail, priority: priority, category: category, date: date, time: time)
        var task = viewModel.dyts.first!
        
        // When
        let updatedTitle = "Updated Task"
        task.dytTitel = updatedTitle
        viewModel.updateDYT(task: task)
        
        // Then
        XCTAssertEqual(viewModel.dyts.count, 1)
        XCTAssertEqual(viewModel.dyts.first?.dytTitel, updatedTitle)
    }
    
    func testAddCategory() {
        // Given
        let newCategory = "New Category"
        
        // When
        viewModel.addCategory(name: newCategory)
        
        // Then
        XCTAssertTrue(viewModel.categories.contains(newCategory))
    }
    
    func testUpdateCategory() {
        // Given
        let oldCategory = "Privat"
        let newCategory = "Personal"
        
        // When
        viewModel.updateCategory(oldName: oldCategory, newName: newCategory)
        
        // Then
        XCTAssertFalse(viewModel.categories.contains(oldCategory))
        XCTAssertTrue(viewModel.categories.contains(newCategory))
    }
    
    func testDeleteCategory() {
        // Given
        let categoryToDelete = "Arbeit"
        
        // When
        viewModel.deleteCategory(name: categoryToDelete)
        
        // Then
        XCTAssertFalse(viewModel.categories.contains(categoryToDelete))
    }
}
