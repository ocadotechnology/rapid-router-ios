//
//  LevelChangeReducer.swift
//  Rapid Router
//
//  Created by Niket Shah on 19/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import Foundation
import ReSwift

func levelChangeReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()

    switch action {
    case let action as ChangeLevel:
        state.level = action.level
    default:
        break
    }

    return state
}
