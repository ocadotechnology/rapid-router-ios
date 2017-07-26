//
//  LevelChooserViewControllerTests.swift
//  Rapid Router
//
//  Created by Niket Shah on 23/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import XCTest
@testable import Rapid_Router
import ReSwift

class LevelChooserViewControllerTests: XCTestCase {
    
    func testNumberOfRowsEqualsNumberOfLevels() {
        let controller = LevelChooserViewController()
        XCTAssertEqual(controller.numberOfSections(in: controller.tableView), 1)
        XCTAssertEqual(controller.tableView(controller.tableView, numberOfRowsInSection: 0), 109)
    }

    func testLevelChangeActionDispatchedOnLevelSelect() {
        let controller = LevelChooserViewController()
        let store = TestStore()
        controller.store = store
        controller.tableView(controller.tableView, didSelectRowAt: IndexPath(row: 4, section: 0))
        XCTAssertEqual(store.dispatchedActions.count, 1)
        XCTAssert(store.dispatchedActions[0] is ChangeLevel)
    }

    func testCellRowReturnsCorrectValue() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LevelChooserViewController") as! LevelChooserViewController
        var cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 5, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "Level 6")
        cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 46, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "Level 47")
        cell = controller.tableView(controller.tableView, cellForRowAt: IndexPath(row: 105, section: 0))
        XCTAssertEqual(cell.textLabel?.text, "Level 106")
    }

    class TestStore: DispatchingStoreType {
        var dispatchedActions: [Action] = []
        func dispatch(_ action: Action) {
            dispatchedActions.append(action)
        }
    }

}
