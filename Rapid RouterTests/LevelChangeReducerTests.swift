//
//  LevelChangeReducerTests.swift
//  Rapid Router
//
//  Created by Niket Shah on 23/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import XCTest
import ReSwift
@testable import Rapid_Router

class LevelChangeReducerTests: XCTestCase {
    
    func testWhenChangeLevelThenCurrentLevelChanged() {
        let store = Store<AppState>(
            reducer: levelChangeReducer,
            state: nil
        )
        store.dispatch(ChangeLevel(level: 4))
        XCTAssertEqual(store.state.level, 4)
        store.dispatch(ChangeLevel(level: 100))
        XCTAssertEqual(store.state.level, 100)
    }
    
}
