import XCTest
@testable import Anime4KMetal

final class Anime4KPresetTests: XCTestCase {
    func testRawValuesAreStableForCLIAndUserDefaults() {
        XCTAssertEqual(Anime4KPreset.modeAFast.rawValue, "modeAFast")
        XCTAssertEqual(Anime4KPreset.modeBFast.rawValue, "modeBFast")
        XCTAssertEqual(Anime4KPreset.modeCFast.rawValue, "modeCFast")
        XCTAssertEqual(Anime4KPreset.modeAAFast.rawValue, "modeAAFast")
        XCTAssertEqual(Anime4KPreset.modeBBFast.rawValue, "modeBBFast")
        XCTAssertEqual(Anime4KPreset.modeCAFast.rawValue, "modeCAFast")
        XCTAssertEqual(Anime4KPreset.modeAHQ.rawValue, "modeAHQ")
        XCTAssertEqual(Anime4KPreset.modeBHQ.rawValue, "modeBHQ")
        XCTAssertEqual(Anime4KPreset.modeCHQ.rawValue, "modeCHQ")
        XCTAssertEqual(Anime4KPreset.modeAAHQ.rawValue, "modeAAHQ")
        XCTAssertEqual(Anime4KPreset.modeBBHQ.rawValue, "modeBBHQ")
        XCTAssertEqual(Anime4KPreset.modeCAHQ.rawValue, "modeCAHQ")
    }

    func testDisplayNamesMatchCinePlayerUI() {
        XCTAssertEqual(Anime4KPreset.modeAFast.displayName, "Mode A (Fast)")
        XCTAssertEqual(Anime4KPreset.modeBFast.displayName, "Mode B (Fast)")
        XCTAssertEqual(Anime4KPreset.modeCFast.displayName, "Mode C (Fast)")
        XCTAssertEqual(Anime4KPreset.modeAAFast.displayName, "Mode A+A (Fast)")
        XCTAssertEqual(Anime4KPreset.modeBBFast.displayName, "Mode B+B (Fast)")
        XCTAssertEqual(Anime4KPreset.modeCAFast.displayName, "Mode C+A (Fast)")
        XCTAssertEqual(Anime4KPreset.modeAHQ.displayName, "Mode A (HQ)")
        XCTAssertEqual(Anime4KPreset.modeBHQ.displayName, "Mode B (HQ)")
        XCTAssertEqual(Anime4KPreset.modeCHQ.displayName, "Mode C (HQ)")
        XCTAssertEqual(Anime4KPreset.modeAAHQ.displayName, "Mode A+A (HQ)")
        XCTAssertEqual(Anime4KPreset.modeBBHQ.displayName, "Mode B+B (HQ)")
        XCTAssertEqual(Anime4KPreset.modeCAHQ.displayName, "Mode C+A (HQ)")
    }

    func testAvailablePresetsArePlatformScoped() {
        #if os(iOS)
        XCTAssertEqual(Anime4KPreset.availablePresets, [
            .modeAFast, .modeBFast, .modeCFast, .modeAAFast, .modeBBFast, .modeCAFast,
        ])
        #else
        XCTAssertEqual(Anime4KPreset.availablePresets, Anime4KPreset.allCases)
        #endif
    }
}
