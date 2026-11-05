import SwiftUI

struct MenuBarContent: View {
    @EnvironmentObject var state: AppState
    @AppStorage(PrefKey.autoSwitch) private var autoSwitch = 1
    @AppStorage(PrefKey.hotkey) private var hotkeyRaw = Hotkey.defaultValue

    var body: some View {
        if state.needsOnboarding {
            Button("Cấp quyền cho Envispeed…") { OnboardingWindow.show() }
            Divider()
        }
        Toggle(isOn: Binding(get: { state.language == 1 }, set: { state.setLanguage($0 ? 1 : 0) })) {
            Text("Tiếng Việt   \(Hotkey(raw: hotkeyRaw).display)")
        }
        Toggle("Tự chuyển Anh/Việt", isOn: Binding(get: { autoSwitch == 1 }, set: { autoSwitch = $0 ? 1 : 0; Preferences.apply() }))
        // Per app: remembered for the app in front (the tick makes SwiftUI re-read it after an app change).
        if state.frontAppTick >= 0 {
            let app = EnvispeedCore.frontAppName()
            if EnvispeedCore.frontAppIsExcluded() {
                Text("\(app): đã loại trừ").foregroundStyle(.secondary)
            } else {
                Toggle("Tự chuyển ở \(app)", isOn: Binding(
                    get: { EnvispeedCore.autoSwitchEnabledForFrontApp() },
                    set: {
                        EnvispeedCore.setAutoSwitchForFrontApp($0)
                        state.frontAppChanged()
                    }))
            }
        }
        Divider()
        Button("Mở Envispeed…") { Windows.main.show() }
            .keyboardShortcut(",")
        Divider()
        Button("Hướng dẫn…") { OnboardingWindow.show() }
        Button("Gửi góp ý…") { Feedback.open() }
        Button("Xem bản phát hành…") { Updater.shared.checkForUpdates() }
        Button("Giới thiệu Envispeed") { AboutPanel.show() }
        Button("Thoát Envispeed") { NSApp.terminate(nil) }
            .keyboardShortcut("q")
    }
}

/// Debug items, in the Envispeed app menu only (not the menu bar icon).
struct DebugMenu: View {
    @AppStorage(PrefKey.typingLogEnabled) private var logEnabled = 0

    var body: some View {
        Menu("Gỡ lỗi") {
            Toggle("Ghi nhật ký gõ", isOn: Binding(get: { logEnabled == 1 }, set: { logEnabled = $0 ? 1 : 0; Preferences.apply() }))
            Button("Xem nhật ký gõ…") { Windows.history.show() }
                .disabled(logEnabled == 0)
        }
    }
}

/// Open the owner's issue form; no typing logs or reports are attached automatically.
enum Feedback {
    static var url: URL {
        URL(string: "https://github.com/chequanghuyca/envispeed/issues/new")!
    }
    static func open() { NSWorkspace.shared.open(url) }
}
