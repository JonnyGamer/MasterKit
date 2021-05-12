//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 5/12/21.
//

//import RegexKit

// Closed Range Raw Value
extension ClosedRange: ExpressibleByUnicodeScalarLiteral where Bound: LosslessStringConvertible {
    public typealias UnicodeScalarLiteralType = String
}
extension ClosedRange: ExpressibleByExtendedGraphemeClusterLiteral where Bound: LosslessStringConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = String
}
extension ClosedRange: ExpressibleByStringLiteral where Bound: LosslessStringConvertible {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        assert(value.contains("..."))
        let sides = value.replacingAll(matching: " ", with: "").splitMiddle(from: "...")
        let theLowerBound = sides.0
        let theUpperBound = sides.1
        self = (Bound(theLowerBound)!)...(Bound(theUpperBound)!)
    }
}
extension ClosedRange: LosslessStringConvertible where Bound: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(stringLiteral: description)
    }
}


// Range Raw Value
extension Range: ExpressibleByUnicodeScalarLiteral where Bound: LosslessStringConvertible {
    public typealias UnicodeScalarLiteralType = String
}
extension Range: ExpressibleByExtendedGraphemeClusterLiteral where Bound: LosslessStringConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = String
}
extension Range: ExpressibleByStringLiteral where Bound: LosslessStringConvertible {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        assert(value.contains("..<"))
        let sides = value.replacingAll(matching: " ", with: "").splitMiddle(from: "..<")
        let theLowerBound = sides.0
        let theUpperBound = sides.1
        assert(theLowerBound <= theUpperBound)
        self = (Bound(theLowerBound)!)..<(Bound(theUpperBound)!)
    }
}
extension Range: LosslessStringConvertible where Bound: LosslessStringConvertible {
    public init?(_ description: String) {
        self.init(stringLiteral: description)
    }
}



// Ranges of sizes of things.
// 0...0 contains 1 element. <  1...10 contains 10 elements
extension ClosedRange: Comparable where Bound: AdditiveArithmetic {
    public static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
        return (lhs.upperBound - lhs.lowerBound) < (rhs.upperBound - rhs.lowerBound)
    }
}
extension Range: Comparable where Bound: AdditiveArithmetic {
    public static func < (lhs: Range<Bound>, rhs: Range<Bound>) -> Bool {
        return (lhs.upperBound - lhs.lowerBound) < (rhs.upperBound - rhs.lowerBound)
    }
}


// Recursive Range Types. i.e. ClosedRange<ClosedRange<... forever ...>>
extension ClosedRange: AdditiveArithmetic where Bound: AdditiveArithmetic {
    public static func - (lhs: Self<Bound>, rhs: Self<Bound>) -> Self<Bound> {
        if lhs < rhs {
            return rhs.lowerBound...(rhs.upperBound - (lhs.upperBound - lhs.lowerBound ))
        } else {
            return lhs.lowerBound...(lhs.upperBound - (rhs.upperBound - rhs.lowerBound ))
        }
    }
    public static func + (lhs: Self<Bound>, rhs: Self<Bound>) -> Self<Bound> {
        return lhs.lowerBound...(lhs.upperBound + ( rhs.upperBound - rhs.lowerBound ))
    }
    public static var zero: Self<Bound> { return (.zero)...(.zero) }
}
extension Range: AdditiveArithmetic where Bound: AdditiveArithmetic {
    public static func - (lhs: Self<Bound>, rhs: Self<Bound>) -> Self<Bound> {
        if lhs < rhs {
            return rhs.lowerBound..<(rhs.upperBound - (lhs.upperBound - lhs.lowerBound ))
        } else {
            return lhs.lowerBound..<(lhs.upperBound - (rhs.upperBound - rhs.lowerBound ))
        }
    }
    public static func + (lhs: Self<Bound>, rhs: Self<Bound>) -> Self<Bound> {
        return lhs.lowerBound..<(lhs.upperBound + ( rhs.upperBound - rhs.lowerBound ))
    }
    public static var zero: Self<Bound> { return (.zero)..<(.zero) }
}
