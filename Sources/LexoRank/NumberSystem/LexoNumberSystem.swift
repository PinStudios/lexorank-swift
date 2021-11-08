//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public enum LexoNumberSystemType {
    case base10
    case base36

    internal var numberSystem: LexoNumberSystem {
        switch self {
            case .base10:
                return LexoBase10NumberSystem.instance
            case .base36:
                return LexoBase36NumberSystem.instance
        }
    }
}

protocol LexoNumberSystem {
    static var instance: LexoNumberSystem { get }

    var min: Character { get }
    var mid: Character { get }
    var max: Character { get }

    var name: String { get }
    var base: UInt8 { get }
    var characters: [Character] { get }

    var radixPointChar: Character { get }

    func toDigit(_ char: Character) throws -> UInt8
    func toChar(_ digit: UInt8) throws -> Character
    func toString(_ int: UInt) -> [Character]
    func toInt(_ string: String) -> UInt?
}

extension LexoNumberSystem {

    func toString(_ int: UInt) -> [Character] {
        return Array<Character>(String(int, radix: Int(base), uppercase: false))
    }

    func toInt(_ string: String) -> UInt? {
        return UInt(string, radix: Int(base))
    }

}
