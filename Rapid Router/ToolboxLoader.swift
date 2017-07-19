//
//  ToolboxLoader.swift
//  Rapid Router
//
//  Created by Niket Shah on 19/07/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import Foundation
import Blockly

struct ToolboxLoader {
    
    let workbench: WorkbenchViewController

    func loadToolbox(level: Int) {
        do {
            let toolbox = try getToolbox(level: level)
            try workbench.loadToolbox(toolbox)
        } catch let error {
            print("An error occurred loading the toolbox: \(error)")
        }
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
