// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Crypto",
    products: [
        .library(name: "Crypto", targets: ["CArgon2", "Crypto"])
    ],
    dependencies: [
        .package(url: "https://github.com/Zewo/Zewo.git", .branch("swift-4")),
    ],
    targets: [
        .target(name: "CArgon2"),
        .target(name: "Crypto", dependencies: ["CArgon2", "Zewo"]),

        .testTarget(name: "CryptoTests", dependencies: ["Crypto"]),
    ]
)
