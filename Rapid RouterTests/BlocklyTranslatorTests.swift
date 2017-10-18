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

    let blockFactory: BlockFactory = {
        let factory = BlockFactory()
        try! factory.load(fromJSONPaths: ["CustomBlocks.json"])
        return factory
    }()
    
    func testStartMethod() {
        // Given
        let block = try! blockFactory.makeBlock(name: "start")
        let startMethod = Method.with {
            $0.name = "start"
            $0.instructions = []
        }
        var expectedCode = Code()
        expectedCode.methods = [startMethod]

        let translator = BlocklyTranslator(rootBlock: block)
        
        // When
        let actualCode = try! translator.translateToCode()

        // Then
        XCTAssertEqual(expectedCode, actualCode)
    }

    func testRootBlockNotStart() {
        // Given
        var exceptionCaught = false
        let block = try! BlockBuilder(name: "Not Start").makeBlock()
        let translator = BlocklyTranslator(rootBlock: block)

        // When
        do {
            _ = try translator.translateToCode()
        } catch TranslatorError.rootBlockIsNotStart {
            exceptionCaught = true
        } catch {

        }

        // Then
        XCTAssertTrue(exceptionCaught)
    }

    func testMoveForwardProgram() {
        // Given
        let startBlock = try! blockFactory.makeBlock(name: "start")
        let moveForwardsBlock = try! blockFactory.makeBlock(name: "move_forwards")
        try! startBlock.nextConnection?.connectTo(moveForwardsBlock.previousConnection)

        let moveForwardsInstruction = Instruction.with {
            $0.type = .moveForwards
        }
        let startMethod = Method.with {
            $0.name = "start"
            $0.instructions = [moveForwardsInstruction]
        }
        var expectedCode = Code()
        expectedCode.methods = [startMethod]

        let translator = BlocklyTranslator(rootBlock: startBlock)

        // When
        let actualCode = try! translator.translateToCode()

        // Then
        XCTAssertEqual(expectedCode, actualCode)
    }
    
}
