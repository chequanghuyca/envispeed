import AppKit

/// Crash reports stay on this Mac. Opening a report never uploads it.
enum CrashReporter {
    private static let seenKey = "CrashReportsSeenUntil"

    static func pending() -> [URL] {
        let directory = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library/Logs/DiagnosticReports")
        let seen = UserDefaults.standard.double(forKey: seenKey)
        let since = max(seen, Date().addingTimeInterval(-3 * 86400).timeIntervalSince1970)
        let files =
            (try? FileManager.default.contentsOfDirectory(
                at: directory, includingPropertiesForKeys: [.contentModificationDateKey]
            )) ?? []
        return files.filter { file in
            let name = file.lastPathComponent
            guard name.hasPrefix("Envispeed-") || name.hasPrefix("Envispeed_"),
                ["ips", "crash"].contains(file.pathExtension)
            else { return false }
            let modified =
                (try? file.resourceValues(forKeys: [.contentModificationDateKey]))?
                .contentModificationDate?.timeIntervalSince1970 ?? 0
            return modified > since
        }.sorted { $0.lastPathComponent > $1.lastPathComponent }
    }

    @MainActor static func checkAtLaunch() {
        guard let newest = pending().first else { return }
        UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: seenKey)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let alert = NSAlert()
            alert.messageText = "Envispeed vừa bị thoát đột ngột"
            alert.informativeText =
                "Báo cáo lỗi được lưu trên máy. Bạn có thể mở để xem và chủ động đính kèm khi báo lỗi trên GitHub. Envispeed không tự gửi báo cáo."
            alert.addButton(withTitle: "Xem báo cáo")
            alert.addButton(withTitle: "Để sau")
            NSApp.activate(ignoringOtherApps: true)
            if alert.runModal() == .alertFirstButtonReturn {
                NSWorkspace.shared.activateFileViewerSelecting([newest])
            }
        }
    }
}
