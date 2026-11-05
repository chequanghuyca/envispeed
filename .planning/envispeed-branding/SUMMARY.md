# Envispeed macOS 0.1.1 — dọn thương hiệu và Git

Ngày: 2026-11-06 (Asia/Ho_Chi_Minh)

## Hành vi được giữ nguyên

Giữ engine C++, auto-switch Việt/Anh, các kiểu Telex, vị trí dấu, kiểm tra chính tả, nhớ theo ứng dụng/website, hoàn tác, emoji và phím tắt. Không dùng phần triển khai Swift thử viết mới; phần đó đã chuyển ra ngoài workspace.

## File và screen thay đổi

| Phạm vi | File / thay đổi |
|---|---|
| App entry/bridge | `App/EnvispeedApp.swift`, `App/Core/EnvispeedCore.h`, `.mm`, `Envispeed-Bridging-Header.h`, `App/Envispeed.entitlements`; đổi đồng bộ các tên gọi và notification trong Swift/Objective-C++. |
| Engine | Giữ tên file/cấu trúc, chỉ đổi tên driver, header guard, comment thương hiệu. Logic và dữ liệu không đổi. |
| About | `App/Views/AboutView.swift`, `Windows.swift`: cửa sổ riêng với logo, Envispeed, phiên bản, Che Quang Huy và liên kết repo của người dùng. Không lặp phần giới thiệu thành phần trong About. |
| Pháp lý | `App/Views/LegalNoticesView.swift`, `App/Model/LegalNotices.swift`, `ACKNOWLEDGEMENTS.md`, `LICENSE`: giữ giấy phép, bản quyền và nguồn dữ liệu; truy cập từ About hoặc menu ứng dụng. Không có thay đổi quyền sở hữu đối với code thành phần. |
| Build | `project.yml`, `Tools/macos/build-local.sh`, `App/Info.plist`: đường dẫn/định danh Envispeed, version 0.1.1 (2), hỗ trợ thư mục build kiểm tra riêng và bỏ object cũ sau khi đổi tên. |
| Kiểm thử | Đổi đồng bộ tên C++ driver, biến môi trường và đường dẫn bridge trong Tools; giữ nguyên input/expected values của các ca kiểm thử. |
| Tài liệu | README, CONTRIBUTING, DECISIONS, `.planning/envispeed-branding/`: tập trung macOS và thông tin hiện tại; quyết định gõ giữ mã Dxx để đối chiếu test. |
| Repo | Source nền tảng khác, website và pipeline phát hành cũ được chuyển ra bản sao ngoài workspace. Workflow CI chỉ còn kiểm tra engine và build macOS. |

## Xác minh

- Đối chiếu mọi file Engine với bản sao trước sửa: chỉ có các phép đổi tên thương hiệu/identifier/header guard đã xác định; không đổi thuật toán hoặc dữ liệu số.
- Golden snapshots và corpus `.txt/.tsv/.json`: đối chiếu byte-for-byte, không đổi.
- `zsh Tools/autoswitch/check.sh`: exit 0; 169/169 quy tắc mặc định, 14/14 Simple Telex 1, 14/14 Simple Telex 2, 20/20 lỗi hồi quy; golden không đổi. Driver parity, undo, performance, realistic typing, fat-finger và auto-correct đạt.
- Bộ đánh giá dữ liệu riêng được bỏ qua có thông báo vì không có thư mục dữ liệu trên máy; không tính là đã kiểm tra.
- `ENVISPEED_BUILD_DIR=/Volumes/SSD/envispeed/build/brand-check zsh Tools/macos/build-local.sh`: exit 0, build thành công trước khi thay app đang chạy.
- Format và lint strict AboutView/LegalNoticesView bằng `xcrun swift-format`, indent 4, line length 120, không indent thêm trong #if.
- `zsh -n Tools/macos/build-local.sh`, `plutil -lint App/Info.plist`, parse project/workflow YAML và `git diff --check` so với bản trước khi dọn: đạt.
- Kiểm tra toàn bộ commit gốc bằng `git show --check --root` báo whitespace kế thừa trong engine/bridge và các golden fixtures có dấu cách chủ ý. Không chuẩn hóa dữ liệu fixture hoặc thay đổi engine chỉ để xóa cảnh báo; đây không phải lỗi build hay lỗi test.
- Chụp và kiểm tra About sáng/tối, cửa sổ Pháp lý; ảnh mới tại `design/screenshots/about-light.png` và `about-dark.png`.
- Đã chuyển bản build đã kiểm tra về `build/macos/Envispeed.app`, giữ bản build trước trong backup; `codesign --verify --deep --strict` đạt sau khi chuyển.
- Mở lại app và kiểm tra bằng UI macOS: About 0.1.1 (2) hiển thị Envispeed, Che Quang Huy và nút mở Giấy phép & thành phần. Chưa tự động hóa gõ câu qua event tap; không tự thay quyền hệ thống.
- Quét tên thương hiệu cũ trong source, cấu hình và tài liệu hoạt động: chỉ giữ trong ba file thông báo pháp lý; các header bản quyền của thành phần được giữ nguyên.

## Git và bản sao

Đã lưu Git bundle, source tar và source tham khảo tại `/Volumes/SSD/envispeed-backups/2026-11-06-before-git-cleanup/`. Bản sao giữ nguyên thông báo bản quyền và lịch sử để rollback.

Repository dùng snapshot Envispeed đã kiểm tra làm commit gốc của lịch sử mới do Che Quang Huy tạo; chỉ cấu hình remote `origin` của người dùng. Cách publish: thay main bằng force-with-lease, đối chiếu với SHA remote đã kiểm tra để không ghi đè thay đổi mới của người khác. Thông báo pháp lý của thành phần không bị xóa khi làm sạch Git. Yêu cầu dọn lịch sử và đưa lên repo đích trong cuộc trao đổi cho phép commit/push và thay main bằng force-with-lease; không dùng force không điều kiện.

## Giới hạn phát hành

Chưa tạo DMG hoặc notarize. Build local ký ad-hoc; macOS có thể yêu cầu cấp lại Accessibility sau khi đổi binary. Đường XcodeGen tùy chọn chưa kiểm tra vì công cụ chưa được cài; không thêm dependency.
