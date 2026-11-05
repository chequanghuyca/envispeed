import Foundation

/// Envispeed owns a separate preference domain; never import another app's typing history or settings.
enum Migration {
    static func prepareDefaults() {
        Preferences.register()
        let defaults = UserDefaults.standard
        let key = defaults.integer(forKey: PrefEmoji.hotkey)
        guard key != 0,
            key & 0x700 == 0 || Hotkey.sameKeys(key, defaults.integer(forKey: PrefKey.hotkey))
        else { return }
        defaults.set(0, forKey: PrefEmoji.hotkey)
    }
}
