//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import Foundation

struct LexoRank {
    let bucket: LexoBucket

    init?(string: String, numberSystem: LexoNumberSystem = Base36NumberSystem.instance) {
        let parts = string.split(separator: "|")

        guard parts.count == 2, let bucket = LexoBucket.fromString(String(parts.first!)) else {
            return nil
        }

        self.bucket = bucket
    }
}
