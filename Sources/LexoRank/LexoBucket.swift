//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

/*
 * Bucket is an object associated with all the ranks. Only one bucket is used at one time.
 * A bucket in a system with baseScale of 6, .base36 number system and step of 8, can contain 260 million
 * unique ranks (130mil each way starting at the middle).
 *
 * If LexoRank scale becomes too big, re-rank will be necessary. Next bucket should be used when re-ranking.
 * If LexoRank.next or LexoRank.prev throws LexoRankError.bucketOverflow, you somehow managed to run out of
 * ranks. Perform a re-rank using a different bucket and baseScale bigger by 1 (10 or 36 times more ranks)
 *
 * See also: LexoRank and LexoDecimal
 */
public enum LexoBucket: Character, CaseIterable, Equatable {
    case bucket0 = "0"
    case bucket1 = "1"
    case bucket2 = "2"

    public var string: String {
        return String(self.rawValue)
    }

    /*
     * Returns next bucket for re-rank operation
     */
    public var nextBucket: LexoBucket {
        switch self {
            case .bucket0:
                return .bucket1
            case .bucket1:
                return .bucket2
            case .bucket2:
                return .bucket0
        }
    }
}

extension LexoBucket: CustomStringConvertible {
    public var description: String {
        return string
    }
}
