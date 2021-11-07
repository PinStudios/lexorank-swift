//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public class Base10NumberSystem: LexoNumberSystem {
    public static var instance: LexoNumberSystem = Base10NumberSystem()

    public let name: String = "Base10"
    public let base: UInt8 = 10
    public let radixPointChar: Character = ":"
    public let characters: [Character] = Array("0123456789")

    public func toDigit(_ char: Character) throws -> UInt8 {
        guard char.isASCII, let ascii = char.asciiValue else {
            throw LexoNumberSystemError.invalidChar(char: char, numberSystemName: name)
        }

        switch ascii {
            case 48...57:
                return ascii - 48
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
