//
// Created by Raimundas Sakalauskas on 2021-11-07.
//

import XCTest
@testable import LexoRank

class LexoDecimalTests: XCTestCase {

    let data: [(string: String, numberSystemType: LexoNumberSystemType, baseScale: Int, scale: Int)] = [
        (string: "abcefg", numberSystemType: .base36, baseScale: 6, scale: 6),
        (string: "abcefg:", numberSystemType: .base36, baseScale: 6, scale: 6),
        (string: "abcefg:123" , numberSystemType: .base36, baseScale: 6, scale: 9),

        (string: "abcdefg", numberSystemType: .base36, baseScale: 7, scale: 7),
        (string: "abcdefg:", numberSystemType: .base36, baseScale: 7, scale: 7),
        (string: "abcdefg:123" , numberSystemType: .base36, baseScale: 7, scale: 10),

        (string: "abefg12345", numberSystemType: .base36, baseScale: 10, scale: 10),
        (string: "abefg12345:", numberSystemType: .base36, baseScale: 10, scale: 10),
        (string: "abefg12345:123" , numberSystemType: .base36, baseScale: 10, scale: 13),

        (string: "123456", numberSystemType: .base10, baseScale: 6, scale: 6),
        (string: "123456:", numberSystemType: .base10, baseScale: 6, scale: 6),
        (string: "123456:123" , numberSystemType: .base10, baseScale: 6, scale: 9),

        (string: "1234567", numberSystemType: .base10, baseScale: 7, scale: 7),
        (string: "1234567:", numberSystemType: .base10, baseScale: 7, scale: 7),
        (string: "1234567:123" , numberSystemType: .base10, baseScale: 7, scale: 10),

        (string: "1234567890", numberSystemType: .base10, baseScale: 10, scale: 10),
        (string: "1234567890:", numberSystemType: .base10, baseScale: 10, scale: 10),
        (string: "1234567890:123" , numberSystemType: .base10, baseScale: 10, scale: 13)
    ]
    
    let incorrectBaseScaleData: [(string: String, numberSystemType: LexoNumberSystemType)] = [
        //wrong base scale
        (string: "abceg", numberSystemType: .base36),
        (string: "abceg:", numberSystemType: .base36),
        (string: "abceg:123" , numberSystemType: .base36),

        (string: "abefg123451", numberSystemType: .base36),
        (string: "abefg123451:", numberSystemType: .base36),
        (string: "abefg123451:123" , numberSystemType: .base36),

        (string: "12345", numberSystemType: .base10),
        (string: "12345:", numberSystemType: .base10),
        (string: "12345:123" , numberSystemType: .base10),

        (string: "12345678901", numberSystemType: .base10),
        (string: "12345678901:", numberSystemType: .base10),
        (string: "12345678901:123" , numberSystemType: .base10),

        //two radix chars
        (string: "abc123:efg:", numberSystemType: .base36),
        (string: "abc123:efg:123" , numberSystemType: .base36),

        (string: "abc123:defg:", numberSystemType: .base36),
        (string: "abc123:defg:123" , numberSystemType: .base36),

        (string: "abe123:fg12345:", numberSystemType: .base36),
        (string: "abe123:fg12345:123" , numberSystemType: .base36),

        (string: "123123:456:", numberSystemType: .base10),
        (string: "123123:456:123" , numberSystemType: .base10),

        (string: "123123:4567:", numberSystemType: .base10),
        (string: "123123:4567:123" , numberSystemType: .base10),

        (string: "123123:4567890:", numberSystemType: .base10),
        (string: "123123:4567890:123" , numberSystemType: .base10)
    ]

    let incorrectCharData: [(string: String, numberSystemType: LexoNumberSystemType)] = [
        //wrong base scale
        (string: "abcegaA", numberSystemType: .base36),
        (string: "abcega*", numberSystemType: .base36),
        (string: "abcega " , numberSystemType: .base36),

        (string: "123456a", numberSystemType: .base10),
        (string: "123456*", numberSystemType: .base10),
        (string: "123456 " , numberSystemType: .base10),
    ]


    func test_initWithCorrectScale_matchesBaseScale() {
        for item in data {
            XCTAssertEqual(try LexoDecimal(item.string, numberSystemType: item.numberSystemType).baseScale, item.baseScale)
        }
    }
    
    func test_initWithIncorrectScale_throws() {
        for item in incorrectBaseScaleData {
            XCTAssertThrowsError(try LexoDecimal(item.string, numberSystemType: item.numberSystemType))
        }
    }
    
    func test_init_correctScale() {
        for item in data {
            XCTAssertEqual(try LexoDecimal(item.string, numberSystemType: item.numberSystemType).scale, item.scale)
        }
    }
    
    func test_performShift_correctScale() {
        for item in data {
            XCTAssertEqual(try LexoDecimal(item.string, numberSystemType: item.numberSystemType).shifting(10).scale, item.scale + 10)
        }
    }

    func test_initWithIncorrectCharInString_throws() {
        for item in incorrectCharData {
            XCTAssertThrowsError(try LexoDecimal(item.string, numberSystemType: item.numberSystemType))
        }
    }

    func test_stepDecimal_validValue() {
        let decimal36 = try! LexoDecimal("123abc", numberSystemType: .base36)

        XCTAssertEqual(try! decimal36.stepDecimal(step: 8).string, "000008:")
        XCTAssertEqual(try! decimal36.stepDecimal(step: 0).string, "000000:")
        XCTAssertEqual(try! decimal36.stepDecimal(step: 15).string, "00000f:")
        XCTAssertEqual(try! decimal36.stepDecimal(step: 40).string, "000014:")
        XCTAssertEqual(try! decimal36.stepDecimal(step: 255).string, "000073:")
        
        let decimal10 = try! LexoDecimal("123456", numberSystemType: .base10)

        XCTAssertEqual(try! decimal10.stepDecimal(step: 8).string, "000008:")
        XCTAssertEqual(try! decimal10.stepDecimal(step: 0).string, "000000:")
        XCTAssertEqual(try! decimal10.stepDecimal(step: 15).string, "000015:")
        XCTAssertEqual(try! decimal10.stepDecimal(step: 40).string, "000040:")
        XCTAssertEqual(try! decimal10.stepDecimal(step: 255).string, "000255:")
    }
    
    func test_addition_noOverflow() {
        let decimal36a = try! LexoDecimal("000000", numberSystemType: .base36)
        let decimal36b = try! LexoDecimal("123456", numberSystemType: .base36)
        let decimal36c = try! LexoDecimal("ghijkl:", numberSystemType: .base36)
        let decimal36d = try! LexoDecimal("0hijkl:", numberSystemType: .base36)
        
        let decimal36e = try! LexoDecimal("ghijkl:123", numberSystemType: .base36)
        let decimal36f = try! LexoDecimal("0hijkl:ghj", numberSystemType: .base36)
        let decimal36g = try! LexoDecimal("0hijkl:xyz", numberSystemType: .base36)
        
        XCTAssertEqual(try? (decimal36a + decimal36b).string, "123456:")
        XCTAssertEqual(try? (decimal36b + decimal36c).string, "hjlnpr:")
        XCTAssertEqual(try? (decimal36c + decimal36d).string, "gz1356:")
        
        XCTAssertEqual(try? (decimal36e + decimal36f).string, "gz1356:hjm")
        XCTAssertEqual(try? (decimal36f + decimal36g).string, "0z1357:egi")
        
        let decimal10a = try! LexoDecimal("000000", numberSystemType: .base10)
        let decimal10b = try! LexoDecimal("123456", numberSystemType: .base10)
        let decimal10c = try! LexoDecimal("456789:", numberSystemType: .base10)
        let decimal10d = try! LexoDecimal("056789:", numberSystemType: .base10)
        
        let decimal10e = try! LexoDecimal("456789:123", numberSystemType: .base10)
        let decimal10f = try! LexoDecimal("056789:678", numberSystemType: .base10)
        let decimal10g = try! LexoDecimal("056789:789", numberSystemType: .base10)
        
        XCTAssertEqual(try? (decimal10a + decimal10b).string, "123456:")
        XCTAssertEqual(try? (decimal10b + decimal10c).string, "580245:")
        XCTAssertEqual(try? (decimal10c + decimal10d).string, "513578:")

        XCTAssertEqual(try? (decimal10e + decimal10f).string, "513578:801")
        XCTAssertEqual(try? (decimal10f + decimal10g).string, "113579:467")
    }

    func test_addition_overflow() {
        let decimal36c = try! LexoDecimal("ghijkl", numberSystemType: .base36)
        let decimal36d = try! LexoDecimal("pqrstu", numberSystemType: .base36)

        XCTAssertThrowsError(try decimal36c + decimal36d)
        
        let decimal10c = try! LexoDecimal("456789", numberSystemType: .base10)
        let decimal10d = try! LexoDecimal("567890", numberSystemType: .base10)
        
        XCTAssertThrowsError(try decimal10c + decimal10d)
    }
    
    func test_additionMismatch_throws() {
        let decimal36c = try! LexoDecimal("123456", numberSystemType: .base36)
        let decimal36d = try! LexoDecimal("abcdefg", numberSystemType: .base36)

        XCTAssertThrowsError(try decimal36c + decimal36d)
        
        let decimal10c = try! LexoDecimal("123456", numberSystemType: .base10)
        let decimal10d = try! LexoDecimal("1234567", numberSystemType: .base10)
        
        XCTAssertThrowsError(try decimal10c + decimal10d)
        
        XCTAssertThrowsError(try decimal10c + decimal36d)
        XCTAssertThrowsError(try decimal36c + decimal10d)
    }
    
    func test_substraction_noOverflow() {
        let decimal36a = try! LexoDecimal("000000", numberSystemType: .base36)
        let decimal36b = try! LexoDecimal("123456", numberSystemType: .base36)
        let decimal36c = try! LexoDecimal("ghijkl:", numberSystemType: .base36)
        let decimal36d = try! LexoDecimal("0hijkl:", numberSystemType: .base36)
        
        let decimal36e = try! LexoDecimal("123456:456", numberSystemType: .base36)
        let decimal36f = try! LexoDecimal("0hijkl:123", numberSystemType: .base36)
        let decimal36g = try! LexoDecimal("00ijkl:456", numberSystemType: .base36)

        XCTAssertEqual(try? (decimal36b - decimal36a).string, "123456:")
        XCTAssertEqual(try? (decimal36c - decimal36b).string, "ffffff:")
        XCTAssertEqual(try? (decimal36b - decimal36d).string, "0kkkkl:")
        
        XCTAssertEqual(try? (decimal36e - decimal36f).string, "0kkkkl:333")
        XCTAssertEqual(try? (decimal36f - decimal36g).string, "0gzzzz:wwx")
        
        let decimal10a = try! LexoDecimal("000000", numberSystemType: .base10)
        let decimal10b = try! LexoDecimal("123456", numberSystemType: .base10)
        let decimal10c = try! LexoDecimal("456789:", numberSystemType: .base10)
        let decimal10d = try! LexoDecimal("056789:", numberSystemType: .base10)
        
        let decimal10e = try! LexoDecimal("456789:456", numberSystemType: .base10)
        let decimal10f = try! LexoDecimal("056789:123", numberSystemType: .base10)
        let decimal10g = try! LexoDecimal("006789:456", numberSystemType: .base10)
        
        XCTAssertEqual(try? (decimal10b - decimal10a).string, "123456:")
        XCTAssertEqual(try? (decimal10c - decimal10b).string, "333333:")
        XCTAssertEqual(try? (decimal10b - decimal10d).string, "066667:")
        
        XCTAssertEqual(try? (decimal10e - decimal10f).string, "400000:333")
        XCTAssertEqual(try? (decimal10f - decimal10g).string, "049999:667")
    }

    func test_substraction_overflow() {
        let decimal36c = try! LexoDecimal("ghijkl", numberSystemType: .base36)
        let decimal36d = try! LexoDecimal("pqrstu", numberSystemType: .base36)

        XCTAssertThrowsError(try decimal36c - decimal36d)
        
        let decimal10c = try! LexoDecimal("456789", numberSystemType: .base10)
        let decimal10d = try! LexoDecimal("567890", numberSystemType: .base10)
        
        XCTAssertThrowsError(try decimal10c - decimal10d)
    }
    
    func test_substraction_throws() {
        let decimal36c = try! LexoDecimal("123456", numberSystemType: .base36)
        let decimal36d = try! LexoDecimal("abcdefg", numberSystemType: .base36)

        XCTAssertThrowsError(try decimal36c - decimal36d)
        
        let decimal10c = try! LexoDecimal("123456", numberSystemType: .base10)
        let decimal10d = try! LexoDecimal("1234567", numberSystemType: .base10)
        
        XCTAssertThrowsError(try decimal10c - decimal10d)
        
        XCTAssertThrowsError(try decimal10c - decimal36d)
        XCTAssertThrowsError(try decimal36c - decimal10d)
    }

    func test_next_validValue() {
        let decimal36 = try! LexoDecimal("123456", numberSystemType: .base36)

        XCTAssertEqual(try! decimal36.next(step: 8).string, "12345e:")
        XCTAssertEqual(try! decimal36.next(step: 0).string, "123456:")
        XCTAssertEqual(try! decimal36.next(step: 15).string, "12345l:")
        XCTAssertEqual(try! decimal36.next(step: 35).string, "123465:")
        XCTAssertEqual(try! decimal36.next(step: 255).string, "1234c9:")

        let decimal10 = try! LexoDecimal("123456", numberSystemType: .base10)

        XCTAssertEqual(try! decimal10.next(step: 8).string, "123464:")
        XCTAssertEqual(try! decimal10.next(step: 0).string, "123456:")
        XCTAssertEqual(try! decimal10.next(step: 15).string, "123471:")
        XCTAssertEqual(try! decimal10.next(step: 40).string, "123496:")
        XCTAssertEqual(try! decimal10.next(step: 255).string, "123711:")
    }

    func test_halved_returnsValidDecimal() {
        XCTAssertEqual(try! LexoDecimal("100000", numberSystemType: .base10).halved()!.string, "050000:")
        XCTAssertEqual(try! LexoDecimal("999999", numberSystemType: .base10).halved()!.string, "499999:")
        XCTAssertEqual(try! LexoDecimal("000002", numberSystemType: .base10).halved()!.string, "000001:")
        XCTAssertEqual(try! LexoDecimal("000003", numberSystemType: .base10).halved()!.string, "000001:")

        XCTAssertEqual(try! LexoDecimal("100000", numberSystemType: .base36).halved()!.string, "0i0000:")
        XCTAssertEqual(try! LexoDecimal("999999", numberSystemType: .base36).halved()!.string, "4mmmmm:")
        XCTAssertEqual(try! LexoDecimal("000002", numberSystemType: .base36).halved()!.string, "000001:")
        XCTAssertEqual(try! LexoDecimal("000003", numberSystemType: .base36).halved()!.string, "000001:")
    }

    func test_halvingImpossible_returnsNil() {
        XCTAssertNil(try! LexoDecimal("000001", numberSystemType: .base10).halved())
        XCTAssertNil(try! LexoDecimal("000000", numberSystemType: .base10).halved())

        XCTAssertNil(try! LexoDecimal("000001", numberSystemType: .base36).halved())
        XCTAssertNil(try! LexoDecimal("000000", numberSystemType: .base36).halved())
    }

    func test_equal() {
        XCTAssertTrue(try LexoDecimal("123456", numberSystemType: .base36) == LexoDecimal("123456:", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123456:axz", numberSystemType: .base36) == LexoDecimal("123456:axz", numberSystemType: .base36))
        
        XCTAssertTrue(try LexoDecimal("123450", numberSystemType: .base36) != LexoDecimal("123456:", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123450:axz", numberSystemType: .base36) != LexoDecimal("123456:axz", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123456:axz", numberSystemType: .base36) != LexoDecimal("123456:ax", numberSystemType: .base36))
        
        XCTAssertTrue(try LexoDecimal("123456", numberSystemType: .base10) == LexoDecimal("123456:", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123456:123", numberSystemType: .base10) == LexoDecimal("123456:123", numberSystemType: .base10))
         
        XCTAssertTrue(try LexoDecimal("123450", numberSystemType: .base10) != LexoDecimal("123456:", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123450:123", numberSystemType: .base10) != LexoDecimal("123456:123", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123456:123", numberSystemType: .base10) != LexoDecimal("123456:12", numberSystemType: .base10))
    }
    
    func test_equalMismatch_throws() {
        XCTAssertThrowsError(try LexoDecimal("12345", numberSystemType: .base36) == LexoDecimal("123456:", numberSystemType: .base36))
        XCTAssertThrowsError(try LexoDecimal("123456:axz", numberSystemType: .base36) == LexoDecimal("12345:axz", numberSystemType: .base36))
        
        XCTAssertThrowsError(try LexoDecimal("12345", numberSystemType: .base10) == LexoDecimal("123456:", numberSystemType: .base10))
        XCTAssertThrowsError(try LexoDecimal("123456:123", numberSystemType: .base10) == LexoDecimal("12345:123", numberSystemType: .base10))
         
        XCTAssertThrowsError(try LexoDecimal("123456", numberSystemType: .base10) != LexoDecimal("123456:", numberSystemType: .base36))
        XCTAssertThrowsError(try LexoDecimal("123456", numberSystemType: .base36) != LexoDecimal("123456:", numberSystemType: .base10))
    }

    func test_lessThan_returnsFalse() {
        XCTAssertTrue(try LexoDecimal("123456", numberSystemType: .base36) < LexoDecimal("123457:", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123456:123", numberSystemType: .base36) < LexoDecimal("123457:123", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123456:123", numberSystemType: .base36) < LexoDecimal("123456:124", numberSystemType: .base36))

        XCTAssertTrue(try LexoDecimal("123456", numberSystemType: .base10) < LexoDecimal("123457:", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123456:123", numberSystemType: .base10) < LexoDecimal("123457:123", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123456:123", numberSystemType: .base10) < LexoDecimal("123456:124", numberSystemType: .base10))
    }

    func test_greaterThan_returnsTrue() {
        XCTAssertTrue(try LexoDecimal("123457", numberSystemType: .base36) > LexoDecimal("123456:", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123457", numberSystemType: .base36) > LexoDecimal("123456:123", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123457:123", numberSystemType: .base36) > LexoDecimal("123456:", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123457:123", numberSystemType: .base36) > LexoDecimal("123456:123", numberSystemType: .base36))
        XCTAssertTrue(try LexoDecimal("123456:124", numberSystemType: .base36) > LexoDecimal("123456:123", numberSystemType: .base36))

        XCTAssertTrue(try LexoDecimal("123457", numberSystemType: .base10) > LexoDecimal("123456:", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123457:123", numberSystemType: .base10) > LexoDecimal("123456:", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123457", numberSystemType: .base10) > LexoDecimal("123456:123", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123457:123", numberSystemType: .base10) > LexoDecimal("123456:123", numberSystemType: .base10))
        XCTAssertTrue(try LexoDecimal("123456:124", numberSystemType: .base10) > LexoDecimal("123456:123", numberSystemType: .base10))
    }
}
