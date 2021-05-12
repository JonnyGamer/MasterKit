// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

/*
 This source file is part of the Swift.org open source project

 Copyright 2015 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import PackageDescription

let package = Package(
    name: "MasterKit",
    products: [
        .library(name: "MasterKit", targets: ["MasterKit", "ReferenceKit", "RegexKit", "ExpressibleEnum"]),
        .library(name: "ReferenceKit", targets: ["ReferenceKit"]),
        .library(name: "RegexKit", targets: ["RegexKit"]),
        .library(name: "ExpressibleEnum", targets: ["ExpressibleEnum"]),
    ],
    
    targets: [
        .target(
            name: "MasterKit",
            dependencies: ["ReferenceKit", "RegexKit", "ExpressibleEnum"]),
        
        .target(name: "ReferenceKit", dependencies: []),
        .target(name: "RegexKit", dependencies: []),
        .target(name: "ExpressibleEnum", dependencies: ["RegexKit"]),
        
        .testTarget(
            name: "MasterTests",
            dependencies: ["MasterKit", "ReferenceKit", "RegexKit", "ExpressibleEnum"])
    ]
)
