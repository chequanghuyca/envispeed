import SwiftUI

@main
struct EnvispeedApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var state = AppState.shared

    var body: some Scene {
        MenuBarExtra {
            MenuBarContent()
                .environmentObject(state)
        } label: {
            Image(nsImage: MenuBarIcon.image(vietnamese: state.language == 1))
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("Giới thiệu về Envispeed") { AboutPanel.show() }  // with the credits
                Button("Giấy phép & thành phần…") { Windows.legal.show() }
                Button("Xem bản phát hành…") { Updater.shared.checkForUpdates() }
                Divider()
                DebugMenu()
            }
            CommandGroup(replacing: .appSettings) {
                Button("Mở Envispeed…") { Windows.main.show() }
                    .keyboardShortcut(",")
            }
        }

    }
}
