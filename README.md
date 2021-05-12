# MasterKit
A Perfect Swift Framework. All the Extensions.

MasterKit is a frameowork wrapper.

```swift
import MasterKit
```

 When you import it, it automatically imports these packages:
- ExpressibleEnum
- ReferenceKit
- RegexKit

You can also choose to import these packages individually.

# ExpressibleEnum

Let's you conform your enums to many new raw value types:

```swift
import MasterKit
// or import ExpressibleEnum

// Bool
enum BoolEnum: Bool { 
    case `true` = true
    case `false` = false
}

// Array
case ArrayEnum: [Int] {
    case foo = "[1, 2, 3, 4]"
}

// MultidimensionalArrays
case NDEnum: [[[[[[[[[[Int]]]]]]]]]] {
    case foo = "[[[[[[[[[[0]]]]]]]]]]"
}

// Enum can also conform to Self

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
```

Enums will now be able to conform to:
- Bool
- Array<Element> (where Element: ExpressibleByStringLiteral)
- Set<Element> (where Element: ExpressibleByStringLiteral)
- Dictionary<Key, Value> (where Key, Value : ExpressibleByStringLiteral)
- Range<Bound> (where Bound: ExpressibleByStringLiteral & AdditiveArithmetic)
- ClosedRange<Bound> (where Bound: ExpressibleByStringLiteral & AdditiveArithmetic)
- Self?, Enum

I've also added protocols to these tpyes, for recursive purposes:
- extension Array: ExpressibleByStringLiteral where Element: ExpressibleByStringLiteral
- extension Set: ExpressibleByStringLiteral where Element: ExpressibleByStringLiteral
- extension Dictionary: ExpressibleByStringLiteral where Key: ExpressibleByStringLiteral, Value: ExpressibleByStringLiteral
- extension ClosedRange: ExpressibleByStringLiteral where Bound: ExpressibleByStringLiteral
- extension ClosedRange: Comparable where Bound: AdditiveArithmetic
- extension ClosedRange: AdditiveArithmetic where Bound: AdditiveArithmetic
- extension Range: ExpressibleByStringLiteral where Bound: ExpressibleByStringLiteral
- extension Range: Comparable where Bound: AdditiveArithmetic
- extension Range: AdditiveArithmetic where Bound: AdditiveArithmetic

# ReferenceKit

Create a reference on any Swift value (Even structs!)

```swift
import MasterKit
// or import ReferenceKit

func testReference() {
    var foo = 1
    
    @Reference var this = &foo
    this += 1
    
    assert(foo != 1)
    assert(foo == 2)
}
```

# RegexKit

Added a Regex wrapper object. It's totally optional to use, though.

Important Features:

- matches(String) -> Bool
- replacingAll(matching: String, with: String) -> String
- replacingFirst(matching: String, with: String) -> String
- replacingMiddle(matching: String, with: String) -> String
- splitMiddle(from: String) -> (String, String)

