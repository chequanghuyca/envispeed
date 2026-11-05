import SwiftUI

/// Required notices for included code and data, separate from the product's About screen.
struct LegalNoticesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Giấy phép & thành phần").font(.title2.bold())
                Text(
                    "Envispeed được phân phối theo GPL-3.0, không kèm bảo hành. Bạn có quyền phân phối lại theo các điều khoản của giấy phép. Các thành phần giữ bản quyền của tác giả tương ứng."
                )
                .font(.callout).foregroundStyle(.secondary)
                Text(
                    "Vikey © 2026 Tony Dinh. OpenKey © 2019 Tuyen Mai. Các thông báo bản quyền trong mã nguồn và giấy phép gốc được giữ nguyên."
                )
                .font(.caption).foregroundStyle(.secondary)
                Button("Đọc giấy phép GPL-3.0 trên máy…") {
                    if let url = Bundle.main.url(forResource: "LICENSE", withExtension: nil) {
                        NSWorkspace.shared.open(url)
                    }
                }
                section("Mã nguồn", "Envispeed dùng mã nguồn của:", LegalNotices.code)
                section(
                    "Dữ liệu từ ngữ",
                    "Envispeed tự chuyển Anh/Việt nhờ thống kê từ ngữ đếm từ các nguồn này. Trong ứng dụng chỉ có số liệu thống kê, không có văn bản nào.",
                    LegalNotices.wordData)
                section(
                    "Dữ liệu kiểm thử", "Chỉ dùng để đo và cải thiện độ chính xác, không có trong ứng dụng.",
                    LegalNotices.testData)
            }
            .padding(24)
        }
        .frame(width: 520, height: 600)
        .tint(.brand)
        .accentColor(.brand)
    }

    private func section(_ title: String, _ note: String, _ items: [Credit]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            Text(note).font(.callout).foregroundStyle(.secondary).fixedSize(horizontal: false, vertical: true)
            ForEach(items) { c in
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 1) {
                        Link(c.name, destination: URL(string: c.url)!)
                        Text(c.by).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(c.license).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }
}
