# Anime4KMetal

Native Apple Metal Anime4K-style image enhancement as a Swift Package and CLI.

This package is intentionally independent from CinePlayer. Library APIs operate on
`CVPixelBuffer` and `CGImage`; player callback adapters belong in consuming apps.

## Requirements

- macOS 13+ / iOS 16+
- Xcode 15.3+ / Swift 5.10+
- Metal-capable Apple platform

## Library Usage

## Swift Package Manager Library

```swift
dependencies: [
    .package(url: "https://github.com/cinemore/anime4k-metal.git", branch: "main"),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "Anime4KMetal", package: "anime4k-metal"),
        ]
    ),
]
```

```swift
import Anime4KMetal

let interpolator = try Anime4KInterpolator(
    configuration: .init(preset: .modeAFast)
)

let output = try interpolator.enhance(
    pixelBuffer: input,
    maxOutputWidth: 2560,
    maxOutputHeight: 1440
)
```

## CLI From Source

```bash
swift build -c release
./.build/release/anime4k-metal \
  --input input.png \
  --output output.png \
  --preset modeAFast \
  --max-width 2560 \
  --max-height 1440
```

## Validation

```bash
swift test
swift run anime4k-metal --input Tests/fixtures/input.png --output /tmp/anime4k-output.png
```
