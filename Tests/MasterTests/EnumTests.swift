//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 5/12/21.
//

@testable import MasterKit
import ExpressibleEnum
//@testable import ExpressibleEnum
import XCTest



class EnumTests: XCTestCase {

    
    // Enum Conforms to Bool
    func testEnumConformsToBool() {
        
        // Example 1
        enum A: Bool {
            case a = true
            case b = false
        }
        
        XCTAssert(A.a.rawValue)
        XCTAssert(!A.b.rawValue)
        
        // Example 2
        enum B: Bool {
            case a = true
            case b = false
            case c = 0
        }
        
        XCTAssert(B.c.rawValue)
        XCTAssert(B.a == B.c)
    }
    
    func testEnumConformsToRanges() {
        // Example 1
        enum A: ClosedRange<Int> {
            case a = "1...10"
            case b = "10...20"
            case c = "0...0"
            
            func overlaps(_ with: Self) -> Bool {
                return rawValue.overlaps(with.rawValue)
            }
        }
        
        XCTAssert(A.a.rawValue.overlaps(A.b.rawValue))
        XCTAssert(A.a.overlaps(.b))
        XCTAssert(A.c.rawValue.lowerBound == A.c.rawValue.upperBound)
        
        // Example 2
        enum B: ClosedRange<String> {
            case a = "a...b"
            case b = "b...c"
            
            case c = "a...aaa"
            case d = "aa...aaaa"
        }
        
        XCTAssert(B.a.rawValue.overlaps(B.b.rawValue))
        XCTAssert(B.c.rawValue.overlaps(B.d.rawValue))
        
        // Example 3
        enum C: ClosedRange<Bool> {
            case a = "false...true"
            case b = "false...true "
        }
        XCTAssert(C.a.rawValue.overlaps(C.b.rawValue))
        
    }
    func testEnumConformsToExtremelyRecursiveRanges() {
        // Example 4
        enum D: ClosedRange<ClosedRange<Int>> {
            case a = "1...1...1...1"
            case b = "1...1...1...10"
        }
        XCTAssert(D.a.rawValue.contains(1...1))
        XCTAssert(D.b.rawValue.contains(100...105))
        XCTAssert(!D.b.rawValue.contains(100...111))
        
        // Example 5 - Something is fishy about this example. I'll have to expiriment further
        enum E: Range<Range<Int>> {
            case o = "1..<1..<1..<1"
            case a = "1..<1..<1..<2"
            case b = "1..<1..<1..<10"
        }
        XCTAssert(!E.o.rawValue.contains(1..<1))
        XCTAssert(E.a.rawValue.contains(1..<1))
        XCTAssert(E.b.rawValue.contains(100..<105))
        XCTAssert(!E.b.rawValue.contains(100..<111))
        
        // Example 6
        enum F: ClosedRange<ClosedRange<ClosedRange<Int>>> {
            case a = "1...1...1...1...1...1...1...1"
            case b = "1...1...1...1...1...1...1...10"
        }
        XCTAssert(F.a.rawValue.contains((1...1)...(1...1)))
        XCTAssert(F.b.rawValue.contains((1...1)...(1...5)))
        XCTAssert(!F.b.rawValue.contains((1...1)...(1...500)))
        
        // Example 7: Recursive as much as you want
        enum G: ClosedRange<ClosedRange<ClosedRange<ClosedRange<Int>>>> {
            case a = "1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1"
            case b = "1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...10"
        }
        XCTAssert(G.a.rawValue.overlaps(G.b.rawValue))
        
        // Example 8: Etc. Recursive as much as you want
        enum H: ClosedRange<ClosedRange<ClosedRange<ClosedRange<ClosedRange<Int>>>>> {
            case a = "1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1"
            case b = "1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...1...10"
        }
        XCTAssert(H.a.rawValue.overlaps(H.b.rawValue))
    }
    
    // Enum Conforms to Itself?
    func testEnumConformsToOptionalSelf() {
        
        // Example 1: Enum A Conforms to A?
        enum A: A?, Enum { case foo }
        enum B: Self?, Enum { case foo }
        
        // Example 2: Raw Values = Self?
        enum C: C?, Enum { case foo = "foo" }
        XCTAssert(C.foo == .foo)
        XCTAssert(C.foo.rawValue! == .foo)
        XCTAssert(C.foo.rawValue!.rawValue! == .foo)
        XCTAssert(C.foo == C.foo.rawValue)
        XCTAssert(C.foo == C.foo.rawValue?.rawValue?.rawValue?.rawValue)
        
        // Example 3: Oscillating Raw Values
        enum D: D?, Enum {
            case bar = "bas"
            case bas = "bar"
        }
        XCTAssert(D.bar == D.bas.rawValue)
        XCTAssert(D.bar != .bar.rawValue!)
        XCTAssert(D.bar == .bar.rawValue?.rawValue)
        
        // Example 4: Longer Oscillating Raw Values
        enum E: E?, Enum {
            case a = "b", b = "c", c = "d", d = "e", e = "a"
        }
        // What: Optional(EnumExpressible.(unknown context at $100015bd4).(unknown context at $100015d3c).E.a)
        XCTAssert("\(E.a.rawValue?.rawValue?.rawValue?.rawValue?.rawValue as Any)".contains("unknown context at") )
        XCTAssert(E.a.rawValue!.rawValue!.rawValue!.rawValue!.rawValue! == .a)
        XCTAssert(E.a == .a.rawValue?.rawValue?.rawValue?.rawValue?.rawValue)
        
        // Example 5: Raw Values equal to nil (when it's an Int)
        enum F: F?, Enum {
            case bar = 0
        }
        XCTAssert(F.bar.rawValue == nil)

    }
    
    
    func testEnumConformsToArrays() {
        
    }
    func testEnumConformsToMultidimensionalArrays() {
        
        // 2D Array
        enum TwoDimensionalArray: [[Int]] {
            case a1 = "[]"
            case a2 = "[[]]"
            case a3 = "[[0000000]]"
            case a4 = "[[-1]]"
            case a5 = "[[1,1,1, 1, 1, 1,     1, 1, 1,     1 ]]"
            case a6 = "[[],[],[],[], [], [],[]   ,[], []  ,[]   ,   []]"
            
            case foo = "[[], [1], [2, 3], [3,2,2], [1,1,2, 3,4,4,50,00000,0,-1,-1]]"
        }
        XCTAssert(TwoDimensionalArray.a1.rawValue == [])
        XCTAssert(TwoDimensionalArray.a2.rawValue == [[]])
        XCTAssert(TwoDimensionalArray.a3.rawValue == [[0]])
        XCTAssert(TwoDimensionalArray.a4.rawValue == [[-1]])
        XCTAssert(TwoDimensionalArray.a5.rawValue == [[1,1,1, 1, 1, 1,     1, 1, 1,     1 ]])
        XCTAssert(TwoDimensionalArray.a6.rawValue == [[],[],[],[], [], [],[]   ,[], []  ,[]   ,   []])
        
        XCTAssert(TwoDimensionalArray.foo.rawValue == [[], [1], [2, 3], [3,2,2], [1,1,2, 3,4,4,50,00000,0,-1,-1]])
        
        
        // 12D Array
        enum MagicArrayRecursion: [[[[[[[[[[[[Int]]]]]]]]]]]] {
            case foo = "[[[[[[[[[[[[0]]]]]]]]]]]]"
        }
        XCTAssert(MagicArrayRecursion.foo.rawValue == [[[[[[[[[[[[0]]]]]]]]]]]])
        
        
        // Even 100D Array
        enum OneHundredDArray: [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[Int]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] {
            case foo = "[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[0]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]"
        }
        XCTAssert(OneHundredDArray.foo.rawValue == [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[0]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]])
        
    }

    
}
