import AppKit

/// Until Envispeed has its own signed update feed, only open the owner's release page on request.
/// No background update requests or downloads are made.
final class Updater {
    static let shared = Updater()
    static let releasesURL = URL(string: "https://github.com/chequanghuyca/envispeed/releases")!

    func checkForUpdates() {
        NSWorkspace.shared.open(Self.releasesURL)
    }
}
