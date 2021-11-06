//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

enum LexoNumberSystemError: Error {
    case invalidDigit(digit: UInt8, numberSystemName: String)
    case invalidChar(char: Character, numberSystemName: String)
}

protocol LexoNumberSystem {
    static var instance: LexoNumberSystem { get }

    var name: String { get }
    var base: UInt8 { get }
    var characters: [Character] { get }

    var radixPointChar: Character { get }

    func toDigit(_ char: Character) throws -> UInt8
    func toChar(_ digit: UInt8) throws -> Character
}
