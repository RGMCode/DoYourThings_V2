//
//  DoYourThingDetailViewUITests.swift
//  DoYourThings_V2.xUITests
//
//  Created by RGMCode on 13.07.24.
//

import XCTest

class DoYourThingDetailViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testDetailViewComponents() throws {
        let app = XCUIApplication()
        
        // Ensure the app is in the initial state
        // (adjust this as needed to navigate to the detail view)
        
        // Assuming your detail view is navigated to from a list in the main view
        app.tables.cells.element(boundBy: 0).tap()
        
        // Verify that the title, category, priority, and detail text are displayed
        XCTAssertTrue(app.staticTexts["Datum: "].exists)
        XCTAssertTrue(app.staticTexts["Uhrzeit: "].exists)
        XCTAssertTrue(app.staticTexts["Kategorie: "].exists)
        XCTAssertTrue(app.staticTexts["Priorität: "].exists)
        XCTAssertTrue(app.staticTexts["Titel: "].exists)
        XCTAssertTrue(app.staticTexts["Bearbeiten"].exists)
        
        // Verify the button to open the edit view
        let editButton = app.buttons["Bearbeiten"]
        XCTAssertTrue(editButton.exists)
        editButton.tap()
        
        // Verify that the edit view is presented
        XCTAssertTrue(app.textFields["Titel"].exists)
        XCTAssertTrue(app.textViews["Detailtext"].exists)
    }
}
