import CoreGraphics
import Metal
import XCTest
@testable import Anime4KMetal

final class Anime4KSmokeTests: XCTestCase {
    func testEnhanceSyntheticPixelBufferProducesCappedOutput() throws {
        guard MTLCreateSystemDefaultDevice() != nil else {
            throw XCTSkip("Metal unavailable")
        }
        let input = try makeSyntheticPixelBuffer(width: 64, height: 48)
        let interpolator = try Anime4KInterpolator(
            configuration: .init(preset: .modeAFast, maxOutputWidth: 128, maxOutputHeight: 96)
        )
        let output = try interpolator.enhance(pixelBuffer: input)
        XCTAssertGreaterThanOrEqual(CVPixelBufferGetWidth(output), CVPixelBufferGetWidth(input))
        XCTAssertGreaterThanOrEqual(CVPixelBufferGetHeight(output), CVPixelBufferGetHeight(input))
        XCTAssertLessThanOrEqual(CVPixelBufferGetWidth(output), 128)
        XCTAssertLessThanOrEqual(CVPixelBufferGetHeight(output), 96)
    }

    private func makeSyntheticPixelBuffer(width: Int, height: Int) throws -> CVPixelBuffer {
        let attrs: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
            kCVPixelBufferWidthKey as String: width,
            kCVPixelBufferHeightKey as String: height,
            kCVPixelBufferMetalCompatibilityKey as String: true,
            kCVPixelBufferIOSurfacePropertiesKey as String: [:] as [String: Any],
        ]
        var buffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(
            kCFAllocatorDefault,
            width,
            height,
            kCVPixelFormatType_32BGRA,
            attrs as CFDictionary,
            &buffer
        )
        guard status == kCVReturnSuccess, let buffer else {
            throw Anime4KError.processingFailed("CVPixelBufferCreate failed: \(status)")
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        guard let base = CVPixelBufferGetBaseAddress(buffer) else {
            throw Anime4KError.processingFailed("CVPixelBufferGetBaseAddress failed")
        }
        let stride = CVPixelBufferGetBytesPerRow(buffer)
        for y in 0..<height {
            let row = base.advanced(by: y * stride)
            for x in 0..<width {
                let px = row.advanced(by: x * 4)
                px.storeBytes(of: UInt8((x * 255) / max(1, width - 1)), as: UInt8.self)
                px.advanced(by: 1).storeBytes(of: UInt8((y * 255) / max(1, height - 1)), as: UInt8.self)
                px.advanced(by: 2).storeBytes(of: UInt8(128), as: UInt8.self)
                px.advanced(by: 3).storeBytes(of: UInt8(255), as: UInt8.self)
            }
        }
        return buffer
    }
}
