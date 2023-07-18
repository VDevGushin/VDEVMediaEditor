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
        .package(url: "https://github.com/CombineCommunity/CombineExt.git",
                 .upToNextMajor(from: "1.0.0")),
        
        .package(url: "https://github.com/onevcat/Kingfisher.git",
                 .upToNextMajor(from: "7.0.0")),
        
        .package(url: "https://github.com/guoyingtao/Mantis.git",
                 from: "2.14.1"),
        
        .package(url: "https://github.com/pointfreeco/swift-identified-collections.git", .upToNextMajor(from: "0.8.0")),
        
        .package(url: "https://github.com/JohnSundell/CollectionConcurrencyKit.git", .upToNextMajor(from: "0.2.0")),
        
        .package(url: "https://github.com/SwiftUIX/SwiftUIX",
                 .upToNextMajor(from: "0.1.6")),
        
        .package(url: "https://github.com/Ezaldeen99/BackgroundRemoval.git",
                 from: "0.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "VDEVMediaEditor",
            dependencies: ["Kingfisher",
                           "Mantis",
                           // "YPImagePicker",
                           "SwiftUIX",
                           "CollectionConcurrencyKit",
                           .product(name: "IdentifiedCollections", package: "swift-identified-collections"),
                           "CombineExt",
                           "BackgroundRemoval",
                          ],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "VDEVMediaEditorTests",
            dependencies: ["VDEVMediaEditor"]),
    ]
)
