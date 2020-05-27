//
//  Water_My_PlantsUITests.swift
//  Water My PlantsUITests
//
//  Created by Ezra Black on 5/26/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import XCTest

class Water_My_PlantsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasicNavigation() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app/*@START_MENU_TOKEN@*/.staticTexts["Get Started"]/*[[".buttons[\"Get Started\"].staticTexts[\"Get Started\"]",".staticTexts[\"Get Started\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let myPlantsNavigationBar = app.navigationBars["My Plants"]
        myPlantsNavigationBar.buttons["My Profile"].tap()
        app.navigationBars["My Profile"].buttons["My Plants"].tap()
        myPlantsNavigationBar.buttons["Add"].tap()
        app.navigationBars["Add A Plant"].buttons["My Plants"].tap()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
