//
//  ToolboxLoader.swift
//  Rapid Router
//
//  Created by Niket Shah on 19/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import Foundation
import Blockly

protocol ToolboxLoadable {
    func loadToolbox(level: Int) throws
}

struct ToolboxLoader: ToolboxLoadable {
    
    let workbench: WorkbenchViewController

    func loadToolbox(level: Int) throws {
        let toolbox = try getToolbox(level: level)
        try workbench.loadToolbox(toolbox)
    }

    private func getToolbox(level: Int) throws -> Toolbox {
        let blockFactory = workbench.blockFactory
        let toolboxPath = "\(String(level))Toolbox.xml"
        let bundlePath = Bundle.main.path(forResource: toolboxPath, ofType: nil)!
        let xmlString = try String(
            contentsOfFile: bundlePath, encoding: String.Encoding.utf8)
        return try Toolbox.makeToolbox(
            xmlString: xmlString, factory: blockFactory)
    }
    
}
