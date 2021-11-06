//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import XCTest
@testable import LexoRank

class Base10NumberSystemTests: XCTestCase {
    
    let sut = Base10NumberSystem()

    func test_charsInRange_shouldReturnDigit() {
        XCTAssertEqual(try sut.toDigit("0"), 0)
        XCTAssertEqual(try sut.toDigit("1"), 1)
        XCTAssertEqual(try sut.toDigit("2"), 2)
        XCTAssertEqual(try sut.toDigit("3"), 3)
        XCTAssertEqual(try sut.toDigit("4"), 4)
        XCTAssertEqual(try sut.toDigit("5"), 5)
        XCTAssertEqual(try sut.toDigit("6"), 6)
        XCTAssertEqual(try sut.toDigit("7"), 7)
        XCTAssertEqual(try sut.toDigit("8"), 8)
        XCTAssertEqual(try sut.toDigit("9"), 9)
    }
    
    func test_charsOutsideOfRange_shouldThrow() {
        XCTAssertThrowsError(try sut.toDigit("a"))
        XCTAssertThrowsError(try sut.toDigit("h"))
        XCTAssertThrowsError(try sut.toDigit("z"))
        XCTAssertThrowsError(try sut.toDigit("A"))
        XCTAssertThrowsError(try sut.toDigit("H"))
        XCTAssertThrowsError(try sut.toDigit("Z"))
        XCTAssertThrowsError(try sut.toDigit("-"))
        XCTAssertThrowsError(try sut.toDigit("+"))
        XCTAssertThrowsError(try sut.toDigit(sut.radixPointChar))
        XCTAssertThrowsError(try sut.toDigit(" "))
    }
    
    func test_digitInRange_shouldReturnChar() {
        XCTAssertEqual(try sut.toChar(0), "0")
        XCTAssertEqual(try sut.toChar(1), "1")
        XCTAssertEqual(try sut.toChar(2), "2")
        XCTAssertEqual(try sut.toChar(3), "3")
        XCTAssertEqual(try sut.toChar(4), "4")
        XCTAssertEqual(try sut.toChar(5), "5")
        XCTAssertEqual(try sut.toChar(6), "6")
        XCTAssertEqual(try sut.toChar(7), "7")
        XCTAssertEqual(try sut.toChar(8), "8")
        XCTAssertEqual(try sut.toChar(9), "9")
    }

    func test_digitOutsideOfRange_shouldThrow() {
        XCTAssertThrowsError(try sut.toChar(10))
        XCTAssertThrowsError(try sut.toChar(101))
        XCTAssertThrowsError(try sut.toChar(45))
    }
    
}
