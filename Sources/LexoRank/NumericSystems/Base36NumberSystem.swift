//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

class Base36NumberSystem: NumberSystem {
    let name: String = "Base36"
    let base: UInt8 = 36
    let radixPointChar: Character = ":"
    let characters: [Character] = Array("0123456789abcdefghijklmnopqrstuvwxyz")

    func toDigit(_ char: Character) throws -> UInt8 {
        guard char.isASCII, let ascii = char.asciiValue else {
            throw NumberSystemError.invalidChar(char: char, numberSystemName: name)
        }

        switch ascii {
            case 48...57:
                return ascii - 48
            case 97...122:
                return ascii - 97 + 10; //+ 10 is to digit values
            default:
                throw NumberSystemError.invalidChar(char: char, numberSystemName: name)
        }
    }

    func toChar(_ digit: UInt8) throws -> Character {
        guard digit < characters.count else {
            throw NumberSystemError.invalidDigit(digit: digit, numberSystemName: name)
        }

        return characters[Int(digit)]
    }
}
