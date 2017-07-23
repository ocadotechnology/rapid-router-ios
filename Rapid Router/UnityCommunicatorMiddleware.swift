//
//  UnityCommunicatorMiddleware.swift
//  Rapid Router
//
//  Created by Niket Shah on 23/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import ReSwift

let unityComunicatorMiddleware: Middleware<Any> = { dispatch, getState in
    return { next in
        return { action in
            if let action = action as? ChangeLevel {
                UnitySendMessage("ChapterController", "LevelChangeListener", String(action.level))
            }
            return next(action)
        }
    }
}
