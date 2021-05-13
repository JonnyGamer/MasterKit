//
//  File.swift
//  
//
//  Created by Jonathan Pappas on 5/12/21.
//

import Foundation

// Regex matches with String!
public func ~=(lhs: Regex, rhs: String) -> Bool { return lhs.matches(rhs) }

// Match KeyPaths with Anything!
public func ~=<T>(lhs: KeyPath<T,Bool>, rhs: T) -> Bool {
    return rhs[keyPath: lhs]
}
//public func ~=<T>(lhs: KeyPath<T,(T)->Bool>, rhs: T) -> Bool {
//    return rhs[keyPath: lhs](rhs)
//}


// Match Closures -> Bool with Anything
public func ~=<T>(lhs: (T) -> Bool, rhs: T) -> Bool { return lhs(rhs) }


// Equatable Pattern Matching
public enum EqualPattern<T: Equatable, U: Equatable> {
    case equals(KeyPath<T,U>,U)
    case notEquals(KeyPath<T,U>,U)
    
    func matchingWith(lhs: T) -> Bool {
        switch self {
        case let .equals(foo, bar): return lhs[keyPath: foo] == bar
        case let .notEquals(foo, bar): return lhs[keyPath: foo] != bar
        }
    }
}
public func ~=<T: Equatable, U: Equatable>(lhs: EqualPattern<T,U>, rhs: T) -> Bool {
    return lhs.matchingWith(lhs: rhs)
}


// String Pattern Matching
public enum StringPattern {
    case contains(String)
    case hasPrefix(String)
    case hasSuffix(String)
    
    func matchingWith(lhs: String) -> Bool {
        switch self {
        case .contains(let foo): return foo.contains(lhs)
        case .hasPrefix(let foo): return foo.hasPrefix(lhs)
        case .hasSuffix(let foo): return foo.hasSuffix(lhs)
        }
    }
}
public func ~=(lhs: StringPattern, rhs: String) -> Bool { return lhs.matchingWith(lhs: rhs) }

// Match Other Sequence Types
public enum SequencePattern<T: Sequence> where T.Element: Equatable {
    case contains(T.Element)
    
    func matchingWith(lhs: T) -> Bool {
        switch self {
        case .contains(let foo): return lhs.contains(foo)
        }
    }
}
public func ~=<T: Sequence>(lhs: SequencePattern<T>, rhs: T) -> Bool where T.Element: Equatable {
    return lhs.matchingWith(lhs: rhs)
}




fileprivate func foo() {
    
    switch "hello" {
    case Regex("h"): print("Match!")
    case "h".regex: print("Match!")
    case ".".regex: print("Match!")
    case .contains("c"): print("Match!")
    case .hasPrefix("he"): print("Match!")
    case { $0.hasPrefix("he") }: print("Match!")
    case { _ in true }: print("ok")
    default: fatalError()
    }
    switch [1, 2, 3] {
    case .contains(1): print("Match")
    default: print("Ok")
    }
    switch [1] {
    case \.isEmpty: print("Match")
    case .equals(\.count, 5): print("Match")
    //case \.count: print("Match")
    //case \.contains: print("Match")
    default: print("Ok")
    }
    
    // Answer https://stackoverflow.com/a/47315359/13426627
    let foo = [Int].contains
    foo([1])(1)
    
    let foobar = [Int]().contains(5)
    //foobar.contains(<#T##element: Int##Int#>)
    
}


class MyClass {
    var bar = 0

    private func handleMainAction() -> Int {
        bar = bar + 1
        return bar
    }

    func getMyMainAction() -> ()->Int {
        return self.handleMainAction
    }
}

class AnotherClass {
    func runSomeoneElsesBarFunc(passedFunction:() -> Int) {
        let result = passedFunction()
        print("What I got was \(result)")
    }
}

func fooo() {
    let myInst = MyClass()
    let anotherInst = AnotherClass()
    let barFunc = myInst.getMyMainAction()

    anotherInst.runSomeoneElsesBarFunc(passedFunction: barFunc)
    anotherInst.runSomeoneElsesBarFunc(passedFunction: barFunc)
    anotherInst.runSomeoneElsesBarFunc(passedFunction: barFunc)

}
