// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ZDToolBoxSwift",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "ZDToolBoxSwift",
            targets: ["ZDToolBoxSwift"]
        ),
    ],
    targets: [
        .target(
            name: "ZDToolBoxSwift",
            path: "Source/Classes",
            exclude: [
                "SubClass/UILayoutGuide+Private.h",
                "SubClass/ZDLayoutGuide.swift",
            ]
        ),
    ]
)
