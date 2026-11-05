import SwiftUI

struct AboutView: View {
    private var version: String { Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.1.1" }
    private var build: String { Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "2" }

    var body: some View {
        VStack(spacing: 14) {
            BrandLogo(size: 88)
            Wordmark(size: 28)
            Text("Phiên bản \(version) (\(build))")
                .font(.callout)
                .foregroundStyle(.secondary)
            Text("Gõ tự nhiên. Làm việc liền mạch.")
                .foregroundStyle(.secondary)
            Divider().padding(.vertical, 4)
            VStack(spacing: 4) {
                Text("Phát triển và duy trì bởi").font(.caption).foregroundStyle(.secondary)
                Text("Che Quang Huy").font(.headline)
            }
            HStack(spacing: 12) {
                Link("GitHub", destination: URL(string: "https://github.com/chequanghuyca/envispeed")!)
                Button("Giấy phép & thành phần…") { Windows.legal.show() }
                    .buttonStyle(.link)
            }
            .padding(.top, 4)
            Text("© 2026 Che Quang Huy · Envispeed")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(30)
        .frame(width: 420)
        .tint(.brand)
        .accentColor(.brand)
    }
}
