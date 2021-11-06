//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

struct LexoBucket {
    private static let BUCKET_0 = LexoBucket("0")
    private static let BUCKET_1 = LexoBucket("1")
    private static let BUCKET_2 = LexoBucket("2")

    static let buckets = [BUCKET_0, BUCKET_1, BUCKET_2]
    static let mapping = [BUCKET_0.id: 0, BUCKET_1.id: 1, BUCKET_2.id: 2]

    public let id: Character

    static func fromCharacter(_ char: Character) -> LexoBucket? {
        if let value = mapping[char] {
            return buckets[value]
        }

        return nil
    }

    static func fromString(_ string: String) -> LexoBucket? {
        if let first = string.first {
            return fromCharacter(first)
        }

        return nil
    }

    fileprivate init(_ id: Character) {
        self.id = id
    }

    func toString() -> String {
        return String(id)
    }

    func nextBucket() -> LexoBucket {
        return Self.buckets[(Self.mapping[id]! + 1) / Self.buckets.count]!
    }
}
