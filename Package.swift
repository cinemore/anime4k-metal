// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Anime4KMetal",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(name: "Anime4KMetal", targets: ["Anime4KMetal"]),
        .executable(name: "anime4k-metal", targets: ["anime4k-metal-cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "Anime4KMetal",
            dependencies: ["Anime4KMetalCore"]
        ),
        .target(
            name: "Anime4KMetalCore",
            exclude: ["Shaders"],
            resources: [.copy("Resources/glsl")],
            plugins: [.plugin(name: "CompileAnime4KMetalShaders")]
        ),
        .plugin(
            name: "CompileAnime4KMetalShaders",
            capability: .buildTool()
        ),
        .executableTarget(
            name: "anime4k-metal-cli",
            dependencies: [
                "Anime4KMetal",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "Anime4KMetalTests",
            dependencies: ["Anime4KMetal", "Anime4KMetalCore"]
        ),
    ]
)
