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

    func test_firstWithParams_matchesExpectation() {
        guard let rank = try? LexoRank.first(bucket: .bucket0, baseScale: 6, numberSystemType: .base36) else {
            XCTFail()
            return
        }

        XCTAssertEqual(rank.bucket.id, "0")
        XCTAssertEqual(rank.decimal.baseScale, 6)
        XCTAssertEqual(rank.decimal.numberSystemType, .base36)
        XCTAssertEqual(rank.decimal.string, "hzzzzz:")
        XCTAssertEqual(rank.string, "0|hzzzzz:")
        XCTAssertEqual(rank.decimal.scale, 6)
    }

    func test_nextRank_matchesExpectation() {
        let nextData = [
            (string: "0|hzzzzz:", steps: 1, step: 8, result: "i00007:", system: LexoNumberSystemType.base36),
            (string: "0|hzzzzz:", steps: 2, step: 8, result: "i0000f:", system: LexoNumberSystemType.base36),
            (string: "0|100000:", steps: 200, step: 8, result: "101600:", system: LexoNumberSystemType.base10),
            (string: "0|100000:", steps: 2000, step: 8, result: "116000:", system: LexoNumberSystemType.base10),
            (string: "0|100000:", steps: 200, step: 12, result: "102400:", system: LexoNumberSystemType.base10),
        ]
        
        for item in nextData {
            do {
                var rank = try LexoRank(item.string, numberSystemType: item.system)

                for _ in stride(from: 0, to: item.steps, by: 1) {
                    rank = try rank.next(step: UInt8(item.step))
                }

                XCTAssertEqual(rank.decimal.string, item.result)
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_prevRank_matchesExpecation() {
        let prevData = [
            (string: "0|hzzzzz:", steps: 1, step: 8, result: "hzzzzr:", system: LexoNumberSystemType.base36),
            (string: "0|hzzzzz:", steps: 2, step: 8, result: "hzzzzj:", system: LexoNumberSystemType.base36),
            (string: "0|100000:", steps: 200, step: 8, result: "098400:", system: LexoNumberSystemType.base10),
            (string: "0|100000:", steps: 2000, step: 8, result: "084000:", system: LexoNumberSystemType.base10),
            (string: "0|100000:", steps: 200, step: 12, result: "097600:", system: LexoNumberSystemType.base10),
        ]
        
        for item in prevData {
            do {
                var rank = try LexoRank(item.string, numberSystemType: item.system)

                for _ in stride(from: 0, to: item.steps, by: 1) {
                    rank = try rank.prev(step: UInt8(item.step))
                }

                XCTAssertEqual(rank.decimal.string, item.result)
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_nextOverflowRank_throws() {
        let nextOverflowData = [
            (string: "0|999900:", steps: 13, step: 8, system: LexoNumberSystemType.base10),
            (string: "0|999992:", steps: 1, step: 8, system: LexoNumberSystemType.base10),
            (string: "0|999999:", steps: 1, step: 8, system: LexoNumberSystemType.base10),
        ]

        for item in nextOverflowData {
            do {
                var rank = try LexoRank(item.string, numberSystemType: item.system)

                for _ in stride(from: 0, to: item.steps - 1, by: 1) {
                    rank = try rank.next(step: UInt8(item.step))
                }
                
                XCTAssertThrowsError(try rank.next(step: UInt8(item.step)))
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_prevOverflowRank_throws() {
        let nextOverflowData = [
            (string: "0|000100:", steps: 13, step: 8, system: LexoNumberSystemType.base10),
            (string: "0|000007:", steps: 1, step: 8, system: LexoNumberSystemType.base10),
            (string: "0|000000:", steps: 1, step: 8, system: LexoNumberSystemType.base10),
        ]

        for item in nextOverflowData {
            do {
                var rank = try LexoRank(item.string, numberSystemType: item.system)

                for _ in stride(from: 0, to: item.steps - 1, by: 1) {
                    rank = try rank.prev(step: UInt8(item.step))
                }
                
                XCTAssertThrowsError(try rank.prev(step: UInt8(item.step)))
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_between_matchesExpectation() {
        let betweenData = [
            //string1 < string2
            (string1: "0|000100:", string2: "0|000200:", steps: 1, system: LexoNumberSystemType.base10, result: "000150:"),
            (string1: "0|000100:", string2: "0|000200:", steps: 2, system: LexoNumberSystemType.base10, result: "000125:"),
            (string1: "0|000100:", string2: "0|000200:", steps: 3, system: LexoNumberSystemType.base10, result: "000112:"),
            (string1: "0|000100:", string2: "0|000200:", steps: 4, system: LexoNumberSystemType.base10, result: "000106:"),
            (string1: "0|000100:", string2: "0|000200:", steps: 5, system: LexoNumberSystemType.base10, result: "000103:"),
            (string1: "0|000100:", string2: "0|000200:", steps: 6, system: LexoNumberSystemType.base10, result: "000101:"),
            (string1: "0|000100:", string2: "0|000200:", steps: 7, system: LexoNumberSystemType.base10, result: "000100:5"),
            (string1: "0|000100:", string2: "0|000200:", steps: 8, system: LexoNumberSystemType.base10, result: "000100:2"),
            (string1: "0|000100:", string2: "0|000200:", steps: 9, system: LexoNumberSystemType.base10, result: "000100:1"),
            (string1: "0|000100:", string2: "0|000200:", steps: 10, system: LexoNumberSystemType.base10, result: "000100:05"),
            (string1: "0|000100:", string2: "0|000200:", steps: 11, system: LexoNumberSystemType.base10, result: "000100:02"),
                        
            (string1: "0|000100:", string2: "0|000101", steps: 1, system: LexoNumberSystemType.base10, result: "000100:5"),
            (string1: "0|000100:", string2: "0|000100:5", steps: 1, system: LexoNumberSystemType.base10, result: "000100:2"),
            
            
            //string1 > string2
            (string1: "0|000200:", string2: "0|000100:", steps: 1, system: LexoNumberSystemType.base10, result: "000150:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 2, system: LexoNumberSystemType.base10, result: "000175:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 3, system: LexoNumberSystemType.base10, result: "000187:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 4, system: LexoNumberSystemType.base10, result: "000193:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 5, system: LexoNumberSystemType.base10, result: "000196:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 6, system: LexoNumberSystemType.base10, result: "000198:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 7, system: LexoNumberSystemType.base10, result: "000199:"),
            (string1: "0|000200:", string2: "0|000100:", steps: 8, system: LexoNumberSystemType.base10, result: "000199:5"),
            (string1: "0|000200:", string2: "0|000100:", steps: 9, system: LexoNumberSystemType.base10, result: "000199:7"),
            (string1: "0|000200:", string2: "0|000100:", steps: 10, system: LexoNumberSystemType.base10, result: "000199:8"),
            (string1: "0|000200:", string2: "0|000100:", steps: 11, system: LexoNumberSystemType.base10, result: "000199:9"),
            (string1: "0|000200:", string2: "0|000100:", steps: 12, system: LexoNumberSystemType.base10, result: "000199:95"),
            (string1: "0|000200:", string2: "0|000100:", steps: 13, system: LexoNumberSystemType.base10, result: "000199:97"),
            (string1: "0|000200:", string2: "0|000100:", steps: 14, system: LexoNumberSystemType.base10, result: "000199:98"),
            
            (string1: "0|000101:", string2: "0|000100", steps: 1, system: LexoNumberSystemType.base10, result: "000100:5"),
            (string1: "0|000100:5", string2: "0|000100:", steps: 1, system: LexoNumberSystemType.base10, result: "000100:2"),
        ]
        
        for item in betweenData {
            do {
                let fixedRank = try LexoRank(item.string1, numberSystemType: item.system)
                var flexRank = try LexoRank(item.string2, numberSystemType: item.system)

                for _ in stride(from: 0, to: item.steps, by: 1) {
                    flexRank = try fixedRank.between(other: flexRank)
                }
                
                XCTAssertEqual(flexRank.decimal.string, item.result)
            } catch {
                XCTFail()
            }
        }
    }

}
