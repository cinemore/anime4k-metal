import ArgumentParser

@main
struct Anime4KMetalCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "anime4k-metal",
        abstract: "Native Apple Metal Anime4K-style image enhancement."
    )

    func run() throws {}
}
