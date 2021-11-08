//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

public struct LexoBucket {
    public static let BUCKET_0 = LexoBucket("0")
    public static let BUCKET_1 = LexoBucket("1")
    public static let BUCKET_2 = LexoBucket("2")

    public static let buckets = [BUCKET_0, BUCKET_1, BUCKET_2]
    public static let mapping = [BUCKET_0.id: 0, BUCKET_1.id: 1, BUCKET_2.id: 2]

    public let id: Character

    fileprivate init(_ id: Character) {
        self.id = id
    }

    public static func findById(_ char: Character) -> LexoBucket? {
        if let value = mapping[char] {
            return buckets[value]
        }

        return nil
    }

    public func toString() -> String {
        return String(id)
    }

    public func nextBucket() -> LexoBucket {
        return Self.buckets[(Self.mapping[id]! + 1) / Self.buckets.count]
    }
}

extension LexoBucket: Equatable {
    public static func ==(lhs: LexoBucket, rhs: LexoBucket) -> Bool {
        return lhs.id == rhs.id
    }
}
