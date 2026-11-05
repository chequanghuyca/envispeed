import SwiftUI

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// Envispeed's terracotta accent follows the owner's original artwork.
extension Color {
    static let brand: Color = {
        #if canImport(UIKit)
        return Color(
            UIColor { traits in
                traits.userInterfaceStyle == .dark
                    ? UIColor(red: 1, green: 0.55, blue: 0.38, alpha: 1)
                    : UIColor(red: 0.72, green: 0.22, blue: 0.12, alpha: 1)
            })
        #else
        return Color(
            NSColor(name: nil) { appearance in
                appearance.bestMatch(from: [.darkAqua, .vibrantDark]) != nil
                    ? NSColor(red: 1, green: 0.55, blue: 0.38, alpha: 1)
                    : NSColor(red: 0.72, green: 0.22, blue: 0.12, alpha: 1)
            })
        #endif
    }()
}

struct Wordmark: View {
    var size: CGFloat = 17

    var body: some View {
        (Text("Envi").foregroundColor(.primary) + Text("speed").foregroundColor(.brand))
            .font(.system(size: size, weight: .bold, design: .rounded))
            .accessibilityLabel("Envispeed")
    }
}

#if os(macOS)
struct BrandLogo: View {
    var size: CGFloat = 64

    var body: some View {
        Image("BrandLogo")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .background(.white, in: RoundedRectangle(cornerRadius: size * 0.23))
            .clipShape(RoundedRectangle(cornerRadius: size * 0.23))
            .overlay(RoundedRectangle(cornerRadius: size * 0.23).strokeBorder(.black.opacity(0.06)))
            .accessibilityHidden(true)
    }
}
#endif
