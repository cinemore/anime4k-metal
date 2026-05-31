import Anime4KMetal
import ArgumentParser
import Foundation

@main
struct Anime4KMetalCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "anime4k-metal",
        abstract: "Native Apple Metal Anime4K-style image enhancement."
    )

    @Option(name: [.short, .long], help: "Input image path.")
    var input: String

    @Option(name: [.short, .long], help: "Output PNG path.")
    var output: String

    @Option(name: .long, help: "Preset raw value, for example modeAFast or modeAHQ.")
    var preset: String = Anime4KPreset.modeAFast.rawValue

    @Option(name: .long, help: "Maximum output width.")
    var maxWidth: Int = 2560

    @Option(name: .long, help: "Maximum output height.")
    var maxHeight: Int = 1440

    @Flag(name: .long, help: "Write a left/right A/B comparison image.")
    var abCompare: Bool = false

    @Option(name: .long, help: "Benchmark mode: run enhancement N times and print mean/min/max milliseconds.")
    var bench: Int = 0

    func run() throws {
        guard let parsedPreset = Anime4KPreset(rawValue: preset) else {
            let valid = Anime4KPreset.allCases.map(\.rawValue).joined(separator: ", ")
            FileHandle.standardError.write(
                Data("anime4k-metal: unknown --preset '\(preset)'. Valid: \(valid)\n".utf8)
            )
            throw ExitCode(2)
        }

        let inputURL = URL(fileURLWithPath: input)
        let outputURL = URL(fileURLWithPath: output)
        let image = try ImageIOAdapter.readImage(at: inputURL)
        let interpolator = try Anime4KInterpolator(
            configuration: .init(
                preset: parsedPreset,
                maxOutputWidth: maxWidth,
                maxOutputHeight: maxHeight,
                abCompareEnabled: abCompare
            )
        )

        let enhanced = try interpolator.enhance(image: image)

        if bench > 0 {
            var samples: [Double] = []
            samples.reserveCapacity(bench)
            for _ in 0..<bench {
                let t0 = DispatchTime.now()
                _ = try interpolator.enhance(image: image)
                let t1 = DispatchTime.now()
                samples.append(Double(t1.uptimeNanoseconds &- t0.uptimeNanoseconds) / 1_000_000)
            }
            let mean = samples.reduce(0, +) / Double(samples.count)
            let minValue = samples.min() ?? 0
            let maxValue = samples.max() ?? 0
            let line = String(
                format: "[bench] preset=%@ N=%d mean=%.2f ms min=%.2f ms max=%.2f ms\n",
                parsedPreset.rawValue,
                bench,
                mean,
                minValue,
                maxValue
            )
            FileHandle.standardError.write(Data(line.utf8))
        }

        try ImageIOAdapter.writeImage(enhanced, to: outputURL)
    }
}
