//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public class Base36NumberSystem: LexoNumberSystem {
    public static var instance: LexoNumberSystem = Base36NumberSystem()

    public let name: String = "Base36"
    public let base: UInt8 = 36
    public let radixPointChar: Character = ":"
    public let characters: [Character] = Array("0123456789abcdefghijklmnopqrstuvwxyz")

    public func toDigit(_ char: Character) throws -> UInt8 {
        guard char.isASCII, let ascii = char.asciiValue else {
            throw LexoNumberSystemError.invalidChar(char: char, numberSystemName: name)
        }

        switch ascii {
            case 48...57:
                return ascii - 48
            case 97...122:
                return ascii - 97 + 10; //+ 10 is to digit values
            default:
                throw LexoNumberSystemError.invalidChar(char: char, numberSystemName: name)
        }
    }

    public func toChar(_ digit: UInt8) throws -> Character {
        guard digit < characters.count else {
            throw LexoNumberSystemError.invalidDigit(digit: digit, numberSystemName: name)
        }

        return characters[Int(digit)]
    }
}
