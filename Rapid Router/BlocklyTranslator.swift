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
        if rootBlock.name != "Start" {
            throw TranslatorError.rootBlockIsNotStart
        }
        let startMethod = Method.with {
            $0.name = rootBlock.name
            $0.instructions = []
        }
        let code = Code.with {
            $0.methods = [startMethod]
        }
        return code
    }
}
