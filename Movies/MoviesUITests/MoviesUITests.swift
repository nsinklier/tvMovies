//
//  MoviesUITests.swift
//  MoviesUITests
//
//  Created by Nick Sinklier on 3/5/25.
//

import XCTest

final class MoviesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func test_MovieDetails_movieCanBeAddedToAndRemovedFromWatchlist() throws {
        let app = XCUIApplication()
        app.launch()

        let homeButton = app.buttons["Home"]
        XCTAssertFalse(homeButton.isSelected)
        let detailsButton = app.buttons["Details"]
        
        let detialsPredicate = NSPredicate(format: "hasFocus == true")
        let detialsExpectation = expectation(for: detialsPredicate, evaluatedWith: detailsButton)
        
        wait(for: [detialsExpectation], timeout: 2)
        
        // Navigate to MovieDetails
        XCUIRemote.shared.press(.select)
        
        let addToWatchlistButton = app.buttons["plus.circle"]
        
        let focusPredicate = NSPredicate(format: "hasFocus == true")
        let focusExpectation = expectation(for: focusPredicate, evaluatedWith: addToWatchlistButton)
        
        wait(for: [focusExpectation], timeout: 2)
        
        // Select add to watchlist button
        XCUIRemote.shared.press(.select)
        
        let watchPredicate = NSPredicate(format: "exists == true")
        let watchExpectation = expectation(for: watchPredicate, evaluatedWith: app.buttons["plus.circle.fill"])
        
        wait(for: [watchExpectation], timeout: 2)
        
        // Select remove from watchlist button
        XCUIRemote.shared.press(.select)
        
        let unwatchedPredicate = NSPredicate(format: "exists == true")
        let unwatchedExpectation = expectation(for: unwatchedPredicate, evaluatedWith: app.buttons["plus.circle"])

        wait(for: [unwatchedExpectation], timeout: 2)
    }
}
