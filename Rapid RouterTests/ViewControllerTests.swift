//
//  ViewControllerTests.swift
//  Rapid Router
//
//  Created by Niket Shah on 24/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import XCTest
@testable import Rapid_Router
import ReSwift
import Blockly

class ViewControllerTests: XCTestCase {

    struct AnError: Error {
        
    }

    struct FakeToolboxLoader: ToolboxLoadable {
        let loadToolboxAction: (Int) -> Void

        func loadToolbox(level: Int) throws {
            if level == 5000 {
                throw AnError()
            }
            loadToolboxAction(level)
        }
    }
    
    func testWhenNewStateThenToolboxLoaded() {
        let controller = ViewController()
        var toolboxLevel = 0
        controller.toolboxLoader = FakeToolboxLoader { level in
            toolboxLevel = level
        }
        controller.newState(state: AppState(level: 5))
        XCTAssertEqual(toolboxLevel, 5)
    }

    func testWhenIncorrectNewStateThenHandlesError() {
        let controller = ViewController()
        controller.toolboxLoader = FakeToolboxLoader { level in }
        controller.newState(state: AppState(level: 5000))
    }

    func testStartAndStopUnityWorks() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        _ = controller.view
        controller.startUnity(sender: self)
        controller.stopUnity(sender: self)
    }

    func testStoreSubscriptions() {
        let controller = ViewController()
        let store = TestStore(reducer: levelChangeReducer, state: nil)
        controller.store = store
        controller.viewWillAppear(false)
        XCTAssertNotNil(store.subscriber)
        controller.viewWillDisappear(false)
        XCTAssertNil(store.subscriber)
    }

    func testSendBlocksToUnity() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        _ = controller.view
        let block = try! BlockBuilder(name: "block").makeBlock()
        try! controller.workBenchViewController.workspace?.addBlockTree(block)
        controller.sendBlocksToUnity(self)
    }

    func testStatusBarColorSetter() {
        let controller = ViewController()
        controller.setStatusBarBackgroundColor(color: UIColor.purple)
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as! UIView
        XCTAssertEqual(statusBar.backgroundColor, UIColor.purple)
    }

    class TestStore: Store<AppState> {

        override func dispatch(_ action: Action) {}

        var subscriber: AnyStoreSubscriber?

        override func subscribe<SelectedState, S>(_ subscriber: S, transform: ((Subscription<AppState>) -> Subscription<SelectedState>)?) where S : StoreSubscriber, S.StoreSubscriberStateType == SelectedState {
            self.subscriber = subscriber
        }

        override func unsubscribe(_ subscriber: AnyStoreSubscriber) {
            self.subscriber = nil
        }
    }
    
}
