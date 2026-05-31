import CoreGraphics
import Foundation
import ImageIO

enum ImageIOAdapter {
    static func readImage(at url: URL) throws -> CGImage {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let image = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            throw CLIError.message("failed to read image at \(url.path)")
        }
        return image
    }

    static func writeImage(_ image: CGImage, to url: URL) throws {
        let type = "public.png" as CFString
        guard let destination = CGImageDestinationCreateWithURL(url as CFURL, type, 1, nil) else {
            throw CLIError.message("failed to create image destination at \(url.path)")
        }
        CGImageDestinationAddImage(destination, image, nil)
        guard CGImageDestinationFinalize(destination) else {
            throw CLIError.message("failed to write image at \(url.path)")
        }
    }
}

enum CLIError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case let .message(message): return message
        }
    }
}
