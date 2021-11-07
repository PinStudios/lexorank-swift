//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

struct LexoBucket {
    private static let BUCKET_0 = LexoBucket("0")
    private static let BUCKET_1 = LexoBucket("1")
    private static let BUCKET_2 = LexoBucket("2")

    public static let buckets = [BUCKET_0, BUCKET_1, BUCKET_2]
    public static let mapping = [BUCKET_0.id: 0, BUCKET_1.id: 1, BUCKET_2.id: 2]

    public let id: Character

    fileprivate init(_ id: Character) {
        self.id = id
    }

    public static func fromCharacter(_ char: Character) -> LexoBucket? {
        if let value = mapping[char] {
            return buckets[value]
        }

        return nil
    }

    public static func fromString(_ string: String) -> LexoBucket? {
        if let first = string.first {
            return fromCharacter(first)
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
