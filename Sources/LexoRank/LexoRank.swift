//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public struct LexoRank {
    let bucket: LexoBucket
    let prefix: LexoDecimal!
    let suffix: LexoDecimal!

    public init?(_ string: String, numberSystem: LexoNumberSystem = Base36NumberSystem.instance) {
        let parts = string.split(separator: "|")

        guard parts.count == 2, let bucket = LexoBucket.fromString(String(parts.first!)) else {
            return nil
        }

        self.bucket = bucket
        self.suffix = nil
        self.prefix = nil
    }
}

extension LexoRank: Comparable {
    public static func <(lhs: LexoRank, rhs: LexoRank) -> Bool {
        fatalError("< has not been implemented")
    }

    public static func ==(lhs: LexoRank, rhs: LexoRank) -> Bool {
        fatalError("== has not been implemented")
    }
}

extension LexoRank {
    public static func +(left: LexoRank, right: LexoRank) -> LexoRank {
        return left
    }

    public static func -(left: LexoRank, right: LexoRank) -> LexoRank {
        return right
    }
}
