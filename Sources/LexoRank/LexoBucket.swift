//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

/*
 * Public enum used to hide LexoBucket implementation
 */
public enum LexoBucket: Character, CaseIterable, Equatable {
    case bucket0 = "0"
    case bucket1 = "1"
    case bucket2 = "2"

    var string: String {
        return String(self.rawValue)
    }

    var nextBucket: LexoBucket {
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
