//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

class LexoBase10NumberSystem: LexoNumberSystem {
    static var instance: LexoNumberSystem = LexoBase10NumberSystem()

    var min: Character = "0"
    var mid: Character = "5"
    var max: Character = "9"

    let name: String = "Base10"
    let base: UInt8 = 10
    let radixPointChar: Character = ":"
    let characters: [Character] = Array("0123456789")

    func toDigit(_ char: Character) throws -> UInt8 {
        guard char.isASCII, let ascii = char.asciiValue else {
            throw LexoRankError.invalidNumberSystemChar(char: char, numberSystemName: name)
        }

        switch ascii {
            case 48...57:
                return ascii - 48
            default:
                throw LexoRankError.invalidNumberSystemChar(char: char, numberSystemName: name)
        }
    }

    func toChar(_ digit: UInt8) throws -> Character {
        guard digit < characters.count else {
            throw LexoRankError.invalidNumberSystemDigit(digit: digit, numberSystemName: name)
        }

        return characters[Int(digit)]
    }
}
