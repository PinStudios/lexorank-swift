//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public struct LexoDecimal {

    private(set) public var numberSystemType: LexoNumberSystemType
    private(set) public var string: String
    private(set) public var baseScale: Int

    var characters: [Character]

    public var scale: Int {
        characters.count
    }

    private var numberSystem: LexoNumberSystem {
        return numberSystemType.numberSystem
    }

    init(_ string: String, numberSystemType: LexoNumberSystemType = .base36) throws {
        let numberSystem = numberSystemType.numberSystem

        var string = string
        if string.firstIndex(of: numberSystem.radixPointChar) == nil {
            string = string.appending(String(numberSystem.radixPointChar))
        }

        guard let radixPointIndex = string.firstIndex(of: numberSystem.radixPointChar),
              radixPointIndex == string.lastIndex(of: numberSystem.radixPointChar),
              case let baseScale = string.distance(from: string.startIndex, to: radixPointIndex),
              baseScale >= LexoRank.MIN_BASE_SCALE, baseScale <= LexoRank.MAX_BASE_SCALE else {
            throw LexoRankError.baseScaleOutOfRange
        }

        var characters = Array(string)
        characters.remove(at: baseScale)

        self.baseScale = baseScale
        self.numberSystemType = numberSystemType
        self.string = string
        self.characters = characters

        //validate making sure that all characters are valid for given number system
        for char in characters {
            _ = try numberSystem.toDigit(char)
        }
    }

    mutating func shift(_ count: Int) {
        if count > 0 {
            self.characters.append(contentsOf: Array<Character>(repeating: numberSystem.min, count: count))
        } else {
            let count = min(abs(count), scale - baseScale)
            self.characters.removeLast(count)
        }

        string = String(characters)
        string.insert(numberSystem.radixPointChar, at: string.index(string.startIndex, offsetBy: baseScale))
    }

    func shifting(_ count: Int) -> LexoDecimal {
        var copy = self
        copy.shift(count)
        return copy
    }

    //returns half if LexoDecimal is possible to halve
    func halved() -> LexoDecimal? {
        var over: UInt8 = 0
        var value: UInt8 = 0

        var halved = false

        var newCharacters = Array<Character>(repeating: numberSystem.min, count: scale)

        do {
            for i in stride(from: 0, to: scale, by: 1) {
                value = try (over * numberSystem.base) + numberSystem.toDigit(characters[i])

                //this is used to track that number being halved is bigger than 1 and results in a number bigger than 0
                if value > 1 {
                    halved = true
                }

                over = value % 2
                value = value / 2

                newCharacters[i] = try numberSystem.toChar(value)
            }

            newCharacters.insert(numberSystem.radixPointChar, at: baseScale)

            if !halved {
                return nil
            }

            return try LexoDecimal(String(newCharacters), numberSystemType: numberSystemType)
        } catch {
            return nil
        }

    }

    func between(other: LexoDecimal) throws -> LexoDecimal {
        guard self.baseScale == other.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard self.numberSystemType == other.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = self.matchScale(other: other, sorted: true)

        //if it's possible to halve the difference, return smaller decimal + half, otherwise append mid char
        if let half = try? (scaleMatched.rhs - scaleMatched.lhs).halved() {
            return try scaleMatched.lhs + half
        } else {
            return try LexoDecimal(scaleMatched.lhs.string.appending(String(numberSystem.mid)), numberSystemType: numberSystemType)
        }
    }

    func next(step: UInt) throws -> LexoDecimal {
        do {
            return try (self + stepDecimal(step: step)).shifting(baseScale - scale)
        } catch {
            throw LexoRankError.bucketOverflow
        }
    }

    func prev(step: UInt) throws -> LexoDecimal {
        do {
            return try (self - stepDecimal(step: step)).shifting(baseScale - scale)
        } catch {
            throw LexoRankError.bucketOverflow
        }
    }

    func stepDecimal(step: UInt) throws -> LexoDecimal {
        guard case let stepChars = numberSystem.toString(UInt(step)), stepChars.count > 0 else {
            throw LexoRankError.unknownError
        }

        let stepString = String(Array<Character>(repeating: numberSystem.min, count: baseScale - stepChars.count)).appending(String(stepChars))

        return try LexoDecimal(stepString, numberSystemType: numberSystemType)
    }

    func matchScale(other: LexoDecimal, sorted: Bool = false) -> (lhs: LexoDecimal, rhs: LexoDecimal) {
        var lhs = self
        var rhs = other

        if lhs.scale < rhs.scale {
            lhs.shift(rhs.scale - lhs.scale)
        } else if lhs.scale > rhs.scale {
            rhs.shift(lhs.scale - rhs.scale)
        }

        if !sorted {
            return (lhs, rhs)
        } else {
            if try! lhs < rhs {
                return (lhs, rhs)
            } else {
                return (rhs, lhs)
            }
        }
    }

}

extension LexoDecimal {
    static func -(lhs: LexoDecimal, rhs: LexoDecimal) throws -> LexoDecimal {
        guard lhs.baseScale == rhs.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard lhs.numberSystemType == rhs.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = lhs.matchScale(other: rhs)
        let numberSystem = lhs.numberSystem
        
        let lhs = scaleMatched.lhs
        let rhs = scaleMatched.rhs

        var over: Int8 = 0
        var value: Int8 = 0

        var newCharacters = Array<Character>(repeating: numberSystem.min, count: lhs.scale)

        for i in stride(from: lhs.scale - 1, through: 0, by: -1) {
            value = try Int8(numberSystem.toDigit(lhs.characters[i])) - Int8(numberSystem.toDigit(rhs.characters[i])) - over

            if value >= 0 {
                over = 0
            } else {
                over = 1
                value += Int8(numberSystem.base)
            }
            newCharacters[i] = try numberSystem.toChar(UInt8(value))
        }

        if over > 0 {
            throw LexoRankError.decimalOverflow
        }

        newCharacters.insert(numberSystem.radixPointChar, at: lhs.baseScale)

        return try LexoDecimal(String(newCharacters), numberSystemType: lhs.numberSystemType)
    }

    static func +(lhs: LexoDecimal, rhs: LexoDecimal) throws -> LexoDecimal {
        guard lhs.baseScale == rhs.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard lhs.numberSystemType == rhs.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = lhs.matchScale(other: rhs, sorted: true)
        let numberSystem = lhs.numberSystem

        let lhs = scaleMatched.lhs
        let rhs = scaleMatched.rhs
        
        var over: UInt8 = 0
        var value: UInt8 = 0

        var newCharacters = Array<Character>(repeating: numberSystem.min, count: lhs.scale)

        for i in stride(from: lhs.scale - 1, through: 0, by: -1) {
            value = try numberSystem.toDigit(lhs.characters[i]) + numberSystem.toDigit(rhs.characters[i]) + over

            over = value / numberSystem.base
            value = value % numberSystem.base

            newCharacters[i] = try numberSystem.toChar(value)
        }

        if over > 0 {
            throw LexoRankError.decimalOverflow
        }

        newCharacters.insert(numberSystem.radixPointChar, at: lhs.baseScale)

        return try LexoDecimal(String(newCharacters), numberSystemType: lhs.numberSystemType)
    }

    static func <(lhs: LexoDecimal, rhs: LexoDecimal) throws -> Bool {
        guard lhs.baseScale == rhs.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard lhs.numberSystemType == rhs.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = lhs.matchScale(other: rhs)

        return scaleMatched.lhs.string < scaleMatched.rhs.string
    }

    static func >(lhs: LexoDecimal, rhs: LexoDecimal) throws -> Bool {
        guard lhs.baseScale == rhs.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard lhs.numberSystemType == rhs.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = lhs.matchScale(other: rhs)

        return scaleMatched.lhs.string > scaleMatched.rhs.string
    }

    static func ==(lhs: LexoDecimal, rhs: LexoDecimal) throws -> Bool {
        guard lhs.baseScale == rhs.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard lhs.numberSystemType == rhs.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = lhs.matchScale(other: rhs)

        return scaleMatched.lhs.string == scaleMatched.rhs.string
    }

    static func !=(lhs: LexoDecimal, rhs: LexoDecimal) throws -> Bool {
        guard lhs.baseScale == rhs.baseScale else {
            throw LexoRankError.baseScaleMismatch
        }

        guard lhs.numberSystemType == rhs.numberSystemType else {
            throw LexoRankError.numberSystemMismatch
        }

        let scaleMatched = lhs.matchScale(other: rhs)

        return scaleMatched.lhs.string != scaleMatched.rhs.string
    }
}

extension LexoDecimal: CustomStringConvertible {
    public var description: String {
        return string
    }
}
