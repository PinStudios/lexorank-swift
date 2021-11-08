//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public enum LexoBucketType: String, CaseIterable {
    case bucket0 = "0"
    case bucket1 = "1"
    case bucket2 = "2"

    internal var bucket: LexoBucket {
        switch self {
            case .bucket0:
                return LexoBucket.BUCKET_0
            case .bucket1:
                return LexoBucket.BUCKET_1
            case .bucket2:
                return LexoBucket.BUCKET_2
        }
    }
}

public struct LexoBucket {
    static let BUCKET_0 = LexoBucket("0")
    static let BUCKET_1 = LexoBucket("1")
    static let BUCKET_2 = LexoBucket("2")

    static let buckets = [BUCKET_0, BUCKET_1, BUCKET_2]
    static let mapping = [BUCKET_0.id: 0, BUCKET_1.id: 1, BUCKET_2.id: 2]

    public let id: Character

    var string: String {
        return String(id)
    }

    fileprivate init(_ id: Character) {
        self.id = id
    }

    static func findById(_ char: Character) -> LexoBucket? {
        if let value = mapping[char] {
            return buckets[value]
        }

        return nil
    }

}

extension LexoBucket: Equatable {
    public static func ==(lhs: LexoBucket, rhs: LexoBucket) -> Bool {
        return lhs.id == rhs.id
    }
}
