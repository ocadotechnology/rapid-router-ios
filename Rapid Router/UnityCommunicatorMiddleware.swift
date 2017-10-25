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
            switch action {
            case let action as ChangeLevel:
                UnitySendMessage("ChapterController", "LevelChangeListener", String(action.level))
            case let action as RunCode:
                let string = try! action.code.jsonString()
                UnitySendMessage("ChapterController", "Listen", string)
            default:
                break
            }
            return next(action)
        }
    }
}
