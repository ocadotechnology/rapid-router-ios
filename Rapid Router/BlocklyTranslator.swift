//
//  BlocklyTranslator.swift
//  Rapid Router
//
//  Created by Niket Shah on 02/08/2017.
//  Copyright © 2017 Ocado. All rights reserved.
//

import Blockly
import SwiftProtobuf

enum TranslatorError: Error {
    case rootBlockIsNotStart
}

struct BlocklyTranslator {
    let rootBlock: Block

    func translateToCode() throws -> Code {
        if rootBlock.name != "start" {
            throw TranslatorError.rootBlockIsNotStart
        }
        var currentBlock: Block? = rootBlock.nextBlock
        var instructions: [Instruction] = []
        while let block = currentBlock {
            instructions.append(convertToInstruction(block: block))
            currentBlock = block.nextBlock
        }
        let startMethod = Method.with {
            $0.name = rootBlock.name
            $0.instructions = instructions
        }
        let code = Code.with {
            $0.methods = [startMethod]
        }
        return code
    }

    private func convertToInstruction(block: Block) -> Instruction {
        return Instruction.with {
            switch block.name {
            case "move_forwards":
                $0.type = .moveForwards
            default:
                break
            }
        }
    }
}
