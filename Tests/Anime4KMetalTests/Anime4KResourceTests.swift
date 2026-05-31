import Metal
import XCTest
@testable import Anime4KMetal
@testable import Anime4KMetalCore

final class Anime4KResourceTests: XCTestCase {
    func testShaderCatalogLoadsModeAFastStages() throws {
        let program = try Anime4KShaderCatalog.program(for: .modeAFast)
        XCTAssertEqual(program.name, "Anime4K Mode A (Fast)")
        XCTAssertEqual(program.stages.map(\.name), [
            "Restore/Anime4K_Clamp_Highlights.glsl",
            "Restore/Anime4K_Restore_CNN_M.glsl",
            "Upscale/Anime4K_Upscale_CNN_x2_M.glsl",
            "Upscale/Anime4K_AutoDownscalePre_x2.glsl",
            "Upscale/Anime4K_AutoDownscalePre_x4.glsl",
            "Upscale/Anime4K_Upscale_CNN_x2_S.glsl",
        ])
        XCTAssertTrue(program.stages.allSatisfy { $0.glsl.contains("//!") })
    }

    func testEveryPresetLoadsAtLeastOneStage() throws {
        for preset in Anime4KPreset.allCases {
            let program = try Anime4KShaderCatalog.program(for: preset)
            XCTAssertFalse(program.stages.isEmpty, "Missing stages for \(preset.rawValue)")
            XCTAssertEqual(program.stages.count, program.stageFiles.count)
        }
    }

    func testMetalLibraryContainsConverterKernels() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw XCTSkip("Metal unavailable")
        }
        let library = try Anime4KMetalLibrary.makeDefaultLibrary(device: device)
        let requiredFunctions = [
            "YUV420BiPlanarToRGBA",
            "YUV420PlanarToRGBA",
            "YUV420P010BiPlanarToRGBA",
            "BGRA8ToRGBA",
            "ABCompareSplit",
            "DirectTransfer",
            "CenterResize",
        ]
        for name in requiredFunctions {
            XCTAssertNotNil(library.makeFunction(name: name), "Missing Metal function \(name)")
        }
    }
}
