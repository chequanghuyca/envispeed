import AppKit
import Foundation

// Resize the owner's artwork into the standard macOS icon slots; never redraw the logo.
let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let source = root.appendingPathComponent("design/Envispeed-logo.png")
guard let original = NSImage(contentsOf: source) else {
    fatalError("Cannot read \(source.path)")
}

let output = root.appendingPathComponent("App/Resources/Assets.xcassets/AppIcon.appiconset")
let iconset = root.appendingPathComponent("build/Envispeed.iconset")
try FileManager.default.createDirectory(at: iconset, withIntermediateDirectories: true)
var slots: [[String: String]] = []
for points in [16, 32, 128, 256, 512] {
    for scale in [1, 2] {
        let pixels = points * scale
        let suffix = scale == 2 ? "@2x" : ""
        let filename = "icon_\(points)x\(points)\(suffix).png"
        let bitmap = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: pixels, pixelsHigh: pixels,
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
        )!
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
        let size = CGFloat(pixels)
        let inset = size * 0.07
        let tile = NSRect(x: inset, y: inset, width: size - 2 * inset, height: size - 2 * inset)
        let shape = NSBezierPath(roundedRect: tile, xRadius: size * 0.19, yRadius: size * 0.19)
        shape.addClip()
        NSColor.white.setFill()
        shape.fill()
        NSGraphicsContext.current?.imageInterpolation = .high
        original.draw(in: tile, from: .zero, operation: .sourceOver, fraction: 1)
        NSGraphicsContext.restoreGraphicsState()
        let png = bitmap.representation(using: .png, properties: [:])!
        try png.write(to: output.appendingPathComponent(filename))
        try png.write(to: iconset.appendingPathComponent(filename))
        slots.append(["idiom": "mac", "size": "\(points)x\(points)", "scale": "\(scale)x", "filename": filename])
    }
}
let manifest: [String: Any] = ["images": slots, "info": ["author": "xcode", "version": 1]]
try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted, .sortedKeys])
    .write(to: output.appendingPathComponent("Contents.json"))
print("Generated 10 macOS icon slots from design/Envispeed-logo.png")
