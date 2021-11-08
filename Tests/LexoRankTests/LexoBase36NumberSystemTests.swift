//
// Created by Raimundas Sakalauskas on 2021-11-06.
//

import XCTest
@testable import LexoRank

class Base36NumberSystemTests: XCTestCase {
    
    let sut = LexoBase36NumberSystem()

    func test_charCount_isEqualToBase() {
        XCTAssertEqual(sut.characters.count, Int(sut.base))
    }

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
        XCTAssertEqual(try sut.toDigit("a"), 10)
        XCTAssertEqual(try sut.toDigit("b"), 11)
        XCTAssertEqual(try sut.toDigit("c"), 12)
        XCTAssertEqual(try sut.toDigit("d"), 13)
        XCTAssertEqual(try sut.toDigit("e"), 14)
        XCTAssertEqual(try sut.toDigit("f"), 15)
        XCTAssertEqual(try sut.toDigit("g"), 16)
        XCTAssertEqual(try sut.toDigit("h"), 17)
        XCTAssertEqual(try sut.toDigit("i"), 18)
        XCTAssertEqual(try sut.toDigit("j"), 19)
        XCTAssertEqual(try sut.toDigit("k"), 20)
        XCTAssertEqual(try sut.toDigit("l"), 21)
        XCTAssertEqual(try sut.toDigit("m"), 22)
        XCTAssertEqual(try sut.toDigit("n"), 23)
        XCTAssertEqual(try sut.toDigit("o"), 24)
        XCTAssertEqual(try sut.toDigit("p"), 25)
        XCTAssertEqual(try sut.toDigit("q"), 26)
        XCTAssertEqual(try sut.toDigit("r"), 27)
        XCTAssertEqual(try sut.toDigit("s"), 28)
        XCTAssertEqual(try sut.toDigit("t"), 29)
        XCTAssertEqual(try sut.toDigit("u"), 30)
        XCTAssertEqual(try sut.toDigit("v"), 31)
        XCTAssertEqual(try sut.toDigit("w"), 32)
        XCTAssertEqual(try sut.toDigit("x"), 33)
        XCTAssertEqual(try sut.toDigit("y"), 34)
        XCTAssertEqual(try sut.toDigit("z"), 35)
    }
    
    func test_charsOutsideOfRange_shouldThrow() {
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
        XCTAssertEqual(try sut.toChar(10), "a")
        XCTAssertEqual(try sut.toChar(11), "b")
        XCTAssertEqual(try sut.toChar(12), "c")
        XCTAssertEqual(try sut.toChar(13), "d")
        XCTAssertEqual(try sut.toChar(14), "e")
        XCTAssertEqual(try sut.toChar(15), "f")
        XCTAssertEqual(try sut.toChar(16), "g")
        XCTAssertEqual(try sut.toChar(17), "h")
        XCTAssertEqual(try sut.toChar(18), "i")
        XCTAssertEqual(try sut.toChar(19), "j")
        XCTAssertEqual(try sut.toChar(20), "k")
        XCTAssertEqual(try sut.toChar(21), "l")
        XCTAssertEqual(try sut.toChar(22), "m")
        XCTAssertEqual(try sut.toChar(23), "n")
        XCTAssertEqual(try sut.toChar(24), "o")
        XCTAssertEqual(try sut.toChar(25), "p")
        XCTAssertEqual(try sut.toChar(26), "q")
        XCTAssertEqual(try sut.toChar(27), "r")
        XCTAssertEqual(try sut.toChar(28), "s")
        XCTAssertEqual(try sut.toChar(29), "t")
        XCTAssertEqual(try sut.toChar(30), "u")
        XCTAssertEqual(try sut.toChar(31), "v")
        XCTAssertEqual(try sut.toChar(32), "w")
        XCTAssertEqual(try sut.toChar(33), "x")
        XCTAssertEqual(try sut.toChar(34), "y")
        XCTAssertEqual(try sut.toChar(35), "z")
    }

    func test_digitOutsideOfRange_shouldThrow() {
        XCTAssertThrowsError(try sut.toChar(36))
        XCTAssertThrowsError(try sut.toChar(125))
        XCTAssertThrowsError(try sut.toChar(45))
    }
    
}
