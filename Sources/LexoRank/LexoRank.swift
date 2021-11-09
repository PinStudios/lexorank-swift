//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public enum LexoRankError: Error, CustomDebugStringConvertible, CustomStringConvertible {
    case unknownError

    case decimalOverflow
    
    case bucketMissing
    case bucketOverflow
    case bucketMismatch

    case baseScaleMismatch
    case numberSystemMismatch
    case baseScaleOutOfRange

    case invalidNumberSystemDigit(digit: UInt8, numberSystemName: String)
    case invalidNumberSystemChar(char: Character, numberSystemName: String)

    public var debugDescription: String {
        return description
    }

    public var description: String {
        switch self {
            case .decimalOverflow:
                return "Resulting decimal is overflowing memory boundaries - this can happen either because resulting value is negative number, or requires baseScale resize to fit"
            case .unknownError:
                return "This should never happen, if this happened, please debug and file a github issue."
            case .bucketMissing:
                return "Input string lacks LexoBucket information."
            case .bucketOverflow:
                return "Impossible to add next value to this LexoBucket. Perform rebalancing using LexoRanks with a bigger baseScale."
            case .bucketMismatch:
                return "Impossible to perform operation for given LexoRanks, because they belong to different LexoBuckets."
            case .baseScaleMismatch:
                return "Impossible to perform operation for given LexoRanks, because they have different baseScales."
            case .numberSystemMismatch:
                return "Impossible to perform operation for given LexoRanks, because they have different numberSystems."
            case .invalidNumberSystemDigit(digit: let digit, numberSystemName: let numberSystemName):
                return "Digit '\(digit)' is outside of scope of \(numberSystemName) number system."
            case .invalidNumberSystemChar(char: let char, numberSystemName: let numberSystemName):
                return "Char '\(char)' is outside of scope of \(numberSystemName) number system."
            case .baseScaleOutOfRange:
                return "BaseScale has to be between \(LexoRank.MIN_BASE_SCALE) and \(LexoRank.MAX_BASE_SCALE)"
        }
    }
}

extension LexoRank {
    static let MIN_BASE_SCALE = 6
    static let MAX_BASE_SCALE = 10

    public static func first(bucket: LexoBucket = .bucket0, baseScale: Int = 6, numberSystemType: LexoNumberSystemType = .base36) throws -> LexoRank {
        let minString = String(Array<Character>(repeating: numberSystemType.numberSystem.min, count: baseScale))
        let maxString = String(Array<Character>(repeating: numberSystemType.numberSystem.max, count: baseScale))

        let min = LexoRank(bucket: bucket, decimal: try LexoDecimal(minString, numberSystemType: numberSystemType))
        let max = LexoRank(bucket: bucket, decimal: try LexoDecimal(maxString, numberSystemType: numberSystemType))

        return try min.between(other: max)
    }
}

public struct LexoRank {
    public let bucket: LexoBucket
    public let decimal: LexoDecimal

    public var string: String {
        return "\(bucket.string)|\(decimal.string)"
    }

    public init(_ string: String, numberSystemType: LexoNumberSystemType = .base36) throws {
        guard case let parts = string.split(separator: "|"),
              parts.count == 2,
              let bucketId = parts.first?.first,
              let bucket = LexoBucket(rawValue: bucketId) else {
            throw LexoRankError.bucketMissing
        }

        let decimal = try LexoDecimal(String(parts[1]), numberSystemType: numberSystemType)

        self.bucket = bucket
        self.decimal = decimal
    }

    init(bucket: LexoBucket, decimal: LexoDecimal) {
        self.bucket = bucket
        self.decimal = decimal
    }

    public func between(other: LexoRank) throws -> LexoRank {
        guard self.bucket == other.bucket else {
            throw LexoRankError.bucketMismatch
        }

        let newDecimal = try decimal.between(other: other.decimal)

        return LexoRank(bucket: bucket, decimal: newDecimal)
    }

    public func next(step: UInt = 8) throws -> LexoRank {
        let newDecimal = try decimal.next(step: step)

        return LexoRank(bucket: bucket, decimal: newDecimal)
    }

    public func prev(step: UInt = 8) throws -> LexoRank {
        let newDecimal = try decimal.prev(step: step)

        return LexoRank(bucket: bucket, decimal: newDecimal)
    }
}

extension LexoRank {
    public static func <(lhs: LexoRank, rhs: LexoRank) throws -> Bool {
        return try lhs.decimal < rhs.decimal
    }

    public static func ==(lhs: LexoRank, rhs: LexoRank) throws -> Bool {
        return try lhs.decimal == rhs.decimal
    }

    public static func >(lhs: LexoRank, rhs: LexoRank) throws -> Bool {
        return try lhs.decimal > rhs.decimal
    }

    public static func !=(lhs: LexoRank, rhs: LexoRank) throws -> Bool {
        return try lhs.decimal != rhs.decimal
    }
}

extension LexoRank: CustomStringConvertible {
    public var description: String {
        return string
    }
}
