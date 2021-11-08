//
// Created by Raimundas Sakalauskas on 2021-11-08.
//

import XCTest
@testable import LexoRank

class LexoRankTests: XCTestCase {

    func test_first_validRank() {
        guard let _ = try? LexoRank.first() else {
            XCTFail()
            return
        }
    }

    func test_firstWithParams_matchesResult() {
        guard let rank = try? LexoRank.first(bucket: .bucket0, baseScale: 6, numberSystemType: .base36) else {
            XCTFail()
            return
        }

        XCTAssertEqual(rank.bucket.id, "0")
        XCTAssertEqual(rank.decimal.baseScale, 6)
        XCTAssertEqual(rank.decimal.numberSystemType, .base36)
        XCTAssertEqual(rank.decimal.string, "hzzzzz:")
        XCTAssertEqual(rank.decimal.scale, 6)
    }

}
