//
//  BlocklyTranslatorTests.swift
//  Rapid RouterTests
//
//  Created by Niket Shah on 11/10/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import XCTest
import Blockly
import SwiftProtobuf
@testable import Rapid_Router

class BlocklyTranslatorTests: XCTestCase {
    
    func testStartMethod() {
        // When
        let block = try! BlockBuilder(name: "Start").makeBlock()
        let translator = BlocklyTranslator(rootBlock: block)
        let startMethod = Method.with {
            $0.name = "Start"
            $0.instructions = []
        }
        var expectedCode = Code()
        expectedCode.methods = [startMethod]
        
        // Given
        let actualCode = try! translator.translateToCode()

        // Then
        XCTAssertEqual(expectedCode, actualCode)
    }
    
}
