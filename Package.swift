// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VDEVMediaEditor",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "VDEVMediaEditor",
            targets: ["VDEVMediaEditor"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/onevcat/Kingfisher.git",
            from: "7.9.1"
        ),
        .package(
            url: "https://github.com/guoyingtao/Mantis.git",
            from: "2.14.1"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-identified-collections.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/JohnSundell/CollectionConcurrencyKit.git",
            from: "0.2.0"
        ),
        .package(
            url: "https://github.com/SwiftUIX/SwiftUIX",
            from: "0.1.9"
        ),
    ],
    targets: [
        .target(
            name: "VDEVMediaEditor",
            dependencies: [
                .byName(name: "VDEVEditorFramework"),
                "Kingfisher",
                "Mantis",
                "SwiftUIX",
                "CollectionConcurrencyKit",
                .product(name: "IdentifiedCollections", package: "swift-identified-collections")
            ]
        ),
        .binaryTarget(
            name: "VDEVEditorFramework",
            path: "Sources/VDEVEditorFramework.xcframework"
        )
    ]
)
