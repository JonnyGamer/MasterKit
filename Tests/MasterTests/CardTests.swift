/*
 This source file is part of the Swift.org open source project
 
 Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception
 
 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
*/

import MasterKit
import ExpressibleEnum
//@testable import MasterTests
//@testable import ExpressibleEnum
import XCTest

enum ClosedRangeRawValueInt: ClosedRange<Int> {
    case foo = "1...3"
    case bar = "1...4"
    func overlaps(_ with: Self) -> Bool { return self.rawValue.overlaps(with.rawValue) }
}

enum ClosedRangeRawValueDouble: ClosedRange<Double> {
    case foo = "1.111...2.111"
    case bar = "1.0...4.0"
    case bar2 = "1.0...inf"
    func overlaps(_ with: Self) -> Bool { return self.rawValue.overlaps(with.rawValue) }
}

enum ArrayRawValue: [Int] {
    case foo = "[1, 2, 3]"
}
enum ArrayRawValueRecursion: [[Int]] {
    case foo = "[[1, 2, 3], [2], [3]]"
    case bar = "[[1, 2, 3], [2], [3], []]"
}
enum ArrayRawValueRecursionRecursion: [[[Int]]] {
    case foo = "[[[1, 2, 3], [2], [3, 4, 5]], [[2]], [[3]]]"
}

// Surround Strings with ' single quotes!!
enum ArrayRawValueString: [String] {
    case foo = "['hello', 'there']"
}

// Surround Strings with ' single quotes!!
enum SetRawValueString: Set<String> {
    case foo = "['hello', 'there']"
}

enum DictRawValueString: [Int:Int] {
    case foo = "[5:10, 6:100]"
}
enum DictRawValueStringRecursion: [Int:[Int:Int]] {
    case foo = "[5:[10:100, 1:1000], 6:[100:1000, 10:10000]]"
    case bar = "[5:[:], 6:[100:1000, 10:10000]]"
}

// This syntax is super neat!
enum Hi: Hi?, CaseIterable {
    // public typealias RawValue = Hi?
    case boo = "boo"
    case bot = "bot"
    case too = 0
}
extension Hi: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = Hi.allCases.filter { "\($0)" == value }.first!
    }
}


class CardTests: XCTestCase {
    
    func testRangeRawValues() {
        XCTAssert(ClosedRangeRawValueInt.foo.rawValue == 1...3)
        XCTAssert(ClosedRangeRawValueDouble.foo.rawValue == 1.111...2.111)
        XCTAssert(ClosedRangeRawValueDouble.bar2.rawValue == 1.0...Double.infinity)
        XCTAssert(Double("inf") == Double.infinity)
        XCTAssert(ArrayRawValue.foo.rawValue == [1, 2, 3])
        XCTAssert(ArrayRawValueRecursion.foo.rawValue == [[1, 2, 3], [2], [3]])
        XCTAssert(ArrayRawValueRecursion.bar.rawValue == [[1, 2, 3], [2], [3], []])
        XCTAssert(ArrayRawValueRecursionRecursion.foo.rawValue == [[[1, 2, 3], [2], [3, 4, 5]], [[2]], [[3]]])
        XCTAssert(ArrayRawValueString.foo.rawValue == ["hello", "there"])
        XCTAssert(SetRawValueString.foo.rawValue == ["there", "hello"])
        XCTAssert(DictRawValueString.foo.rawValue == [5:10, 6:100])
        XCTAssert(DictRawValueStringRecursion.foo.rawValue == [5:[10:100, 1:1000], 6:[100:1000, 10:10000]])
        XCTAssert(DictRawValueStringRecursion.bar.rawValue == [5:[:], 6:[100:1000, 10:10000]])
        
        let foo = Hi("boo")
        print(foo)
        //XCTAssert(foo == .boo)
        
    }
    
    
}
