//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

class Base10NumberSystem: NumberSystem {
    private(set) var name: String = "Base10"
    private(set) var base: UInt8 = 10
    private(set) var radixPointChar: Character = "."

    func toDigit(_ char: Character) throws -> UInt8 {
        guard char.isASCII, let ascii = char.asciiValue else {
            throw NumberSystemError.invalidChar(char: char, numberSystemName: name)
        }

        switch ascii {
            case 48...57:
                return ascii - 48
            default:
                throw NumberSystemError.invalidChar(char: char, numberSystemName: name)
        }
    }

    func toChar(_ digit: UInt8) throws -> Character {
        switch digit {
            case 0...9:
                return Character(UnicodeScalar(digit + 48))
            default:
                throw NumberSystemError.invalidDigit(digit: digit, numberSystemName: name)
        }
    }
}
