//
//  fastlane_snapshot.swift
//  fastlane-snapshot
//
//  Created by MEI YIN LO on 2022/12/20.
//

import XCTest

final class fastlane_snapshot: XCTestCase {
    var app : XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        if UIDevice.current.userInterfaceIdiom == .pad{
            XCUIDevice.shared.orientation = .landscapeLeft
        }
        setupSnapshot(app)
        
        
        
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        app.launch()
//        if UIDevice.current.userInterfaceIdiom == .phone{
//            app.navigationBars.matching(identifier: "_TtGC7SwiftUI32NavigationStackHosting")/*@START_MENU_TOKEN@*/.buttons["ToggleSidebar"]/*[[".buttons[\"Hide Sidebar\"]",".buttons[\"ToggleSidebar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//        }
        //app.navigationBars["_TtGC7SwiftUI32NavigationStackHosting"]/*@START_MENU_TOKEN@*/.buttons["ToggleSidebar"]/*[[".buttons[\"Show Sidebar\"]",".buttons[\"ToggleSidebar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
//        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 2).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
        
//
//
//        let collectionViewsQuery = app.collectionViews
//        collectionViewsQuery.children(matching: .cell).element(boundBy: 9).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
//
//        let popoverdismissregionElement = app/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//        popoverdismissregionElement.tap()
//        collectionViewsQuery.children(matching: .cell).element(boundBy: 2).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .button).element.tap()
//        popoverdismissregionElement.tap()
//        let task = Task{
//            try await Task.sleep(for:.seconds(5))
//        }
//        _ = try await task.value
        
        //let app = XCUIApplication()
        
        sleep(2)
        snapshot("snapshot001")
        sleep(4)
        snapshot("snapshot001_1")
        sleep(2)
        snapshot("snapshot001_2")
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            app.tabBars["Tab Bar"].buttons["Edit"].tap()
            snapshot("snapshot002")
            
            let element = app.collectionViews.children(matching: .cell).element(boundBy: 11).children(matching: .other).element(boundBy: 1).children(matching: .other).element
            let button = element.children(matching: .other).element.children(matching: .button).element
            button.tap()
            //app/*@START_MENU_TOKEN@*/.collectionViews.containing(.other, identifier:"Vertical scroll bar, 2 pages").element/*[[".collectionViews.containing(.other, identifier:\"Horizontal scroll bar, 1 page\").element",".collectionViews.containing(.other, identifier:\"Vertical scroll bar, 2 pages\").element"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
            //button.tap()
            snapshot("snapshot003")
            
            let sheetGrabberButton = app.buttons["Sheet Grabber"]
            sheetGrabberButton.swipeUp()
            //sheetGrabberButton/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
//            element.tap()
//            sheetGrabberButton.swipeUp()
//            button.tap()
//            sheetGrabberButton.tap()
            snapshot("snapshot004")
            
        }
        
        
        
        
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    
}
