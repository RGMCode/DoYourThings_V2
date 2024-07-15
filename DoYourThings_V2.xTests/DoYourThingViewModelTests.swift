//
//  DoYourThingViewModelTests.swift
//  DoYourThings_V2.xTests
//
//  Created by RGMCode on 13.07.24.
//

import XCTest
import CoreData
import SwiftUI
@testable import DoYourThings_V2_x

class DoYourThingViewModelTests: XCTestCase {
    var viewModel: DoYourThingViewModel!
    var persistentContainer: NSPersistentContainer!
    
    override func setUpWithError() throws {
        persistentContainer = NSPersistentContainer(name: "DoYourThingModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { (description, error) in
            XCTAssertNil(error)
        }
        
        viewModel = DoYourThingViewModel(context: persistentContainer.viewContext)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        persistentContainer = nil
    }
    
    func testFetchDYT() throws {
        // Given
        let fetchExpectation = expectation(description: "Fetch DYTs")
        
        // When
        viewModel.fetchDYT()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.dyts.count, 0)
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAddDYT() throws {
        // Given
        let addExpectation = expectation(description: "Add DYT")
        
        // When
        viewModel.addDYT(title: "Test Task", detail: "Task Detail", priority: "Mittel", category: "Privat", date: Date(), time: Date())
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.dyts.count, 1)
            XCTAssertEqual(self.viewModel.dyts.first?.dytTitel, "Test Task")
            addExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testDeleteDYT() throws {
        // Given
        let addExpectation = expectation(description: "Add DYT for Deletion")
        viewModel.addDYT(title: "Task to Delete", detail: "Task Detail", priority: "Mittel", category: "Privat", date: Date(), time: Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.dyts.count, 1)
            addExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // When
        let deleteExpectation = expectation(description: "Delete DYT")
        viewModel.deleteDYT(task: viewModel.dyts.first!)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.dyts.count, 0)
            deleteExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUpdateDYT() throws {
        // Given
        let addExpectation = expectation(description: "Add DYT for Update")
        viewModel.addDYT(title: "Task to Update", detail: "Task Detail", priority: "Mittel", category: "Privat", date: Date(), time: Date())
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.dyts.count, 1)
            addExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
        
        // When
        let updateExpectation = expectation(description: "Update DYT")
        var task = viewModel.dyts.first!
        task.dytTitel = "Updated Task"
        viewModel.updateDYT(task: task)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.dyts.first?.dytTitel, "Updated Task")
            updateExpectation.fulfill()
        }
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAddCategory() throws {
        // Given
        let initialCount = viewModel.categories.count
        
        // When
        viewModel.addCategory(name: "New Category", color: .red)
        
        // Then
        XCTAssertEqual(viewModel.categories.count, initialCount + 1)
        XCTAssertEqual(viewModel.categories.last?.name, "New Category")
        XCTAssertEqual(viewModel.categories.last?.color, Color.red)
    }
    
    func testUpdateCategory() throws {
        // Given
        viewModel.addCategory(name: "Category to Update", color: .green)
        XCTAssertEqual(viewModel.categories.count, 3)
        
        // When
        viewModel.updateCategory(oldName: "Category to Update", newName: "Updated Category", color: .yellow)
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 3)
        XCTAssertEqual(viewModel.categories.last?.name, "Updated Category")
        XCTAssertEqual(viewModel.categories.last?.color, Color.yellow)
    }
    
    func testDeleteCategory() throws {
        // Given
        viewModel.addCategory(name: "Category to Delete", color: .blue)
        XCTAssertEqual(viewModel.categories.count, 3)
        
        // When
        viewModel.deleteCategory(name: "Category to Delete")
        
        // Then
        XCTAssertEqual(viewModel.categories.count, 2)
        XCTAssertFalse(viewModel.categories.contains(where: { $0.name == "Category to Delete" }))
    }
    
    func testSearchTasks() throws {
        // Given
        viewModel.addDYT(title: "Test Task 1", detail: "Detail 1", priority: "Mittel", category: "Privat", date: Date(), time: Date())
        viewModel.addDYT(title: "Test Task 2", detail: "Detail 2", priority: "Hoch", category: "Arbeit", date: Date(), time: Date())
        
        // When
        viewModel.searchTasks(query: "Task 1")
        
        // Then
        XCTAssertEqual(viewModel.searchResults.count, 1)
        XCTAssertEqual(viewModel.searchResults.first?.dytTitel, "Test Task 1")
        
        // When
        viewModel.searchTasks(query: "Detail")
        
        // Then
        XCTAssertEqual(viewModel.searchResults.count, 2)
        
        // When
        viewModel.searchTasks(query: "Non-existent")
        
        // Then
        XCTAssertEqual(viewModel.searchResults.count, 0)
    }
}
