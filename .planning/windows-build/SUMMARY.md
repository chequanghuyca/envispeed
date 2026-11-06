# Envispeed Windows 0.1.1

Ngày 2026-11-06 (Asia/Ho_Chi_Minh)

## Nguồn và phạm vi

Lấy phần Windows từ [Vikey main 350efb2](https://github.com/tonyminibot/Vikey/tree/350efb25f49f1462814f69532c55c6e80ab4eb90/Windows). Snapshot này có bản sửa liên kết tĩnh Visual C++ runtime và bản sửa bộ nhớ từ khi di chuyển con trỏ. Engine trong Envispeed khớp với upstream sau khi đối chiếu định danh. App Windows dùng trực tiếp engine hiện có.

| File / khu vực | Màn hình, tính năng và hành vi |
| --- | --- |
| `Windows/App/{Core,KeyMap,Site,Emoji}.*` | Hook bàn phím, Telex, tự chuyển Việt/Anh, hoàn tác, Alt+Z, âm báo, nhớ theo app/trang, bảng emoji và nhật ký gõ tùy chọn. Dùng Win32 và dữ liệu emoji dùng chung. |
| `Windows/App/{main,Settings,Brand,Prefs}.*` | Đổi nhận diện ở khay hệ thống, Cài đặt, Hướng dẫn lần đầu, Giới thiệu, Giấy phép & thành phần và Nhật ký gõ. Registry, dữ liệu và mục tự khởi động dùng định danh Envispeed. Giới thiệu hiển thị Che Quang Huy. Liên kết phát hành và góp ý mở GitHub của Envispeed theo yêu cầu. |
| `Windows/App/CrashReporter.*` | Báo cáo lỗi lưu cục bộ trong `%LOCALAPPDATA%\Envispeed\Crashes`. Lần mở kế tiếp có thể xem báo cáo. Bản Windows dùng thiết lập riêng, theo chính sách cập nhật thủ công và báo cáo cục bộ của macOS. |
| `Windows/CMakeLists.txt`, `Windows/App/CMakeLists.txt`, icon, manifest, RC | Target x64/ARM64. Dùng version/build từ `project.yml`, nhúng icon từ logo Envispeed, hai âm báo và `Emoji.json`. Release liên kết tĩnh C++ runtime. |
| `Windows/installer/Envispeed.iss`, `Windows/package.ps1` | Cài theo tài khoản, shortcut Start Menu, kiểm tra app đang mở khi cài/gỡ và dọn mục Run của Envispeed khi gỡ. Tạo Setup và ZIP portable kèm giấy phép, dùng version và kiến trúc từ EXE. |
| `Windows/check.ps1`, `Windows/Tests/`, `Tools/autoswitch/rules/golden.py` | Build và kiểm thử engine bằng CMake/Ninja. Golden runner hỗ trợ chọn binary riêng từ thư mục build. 29 ca live test dùng keyboard hook trên desktop Windows. |
| `.github/workflows/windows.yml`, `README.md`, `ACKNOWLEDGEMENTS.md` | CI build/test/package cả hai kiến trúc và lưu artifact. Tài liệu build local, điều kiện chạy live test và ghi nhận Vikey/OpenKey. |

## Xác minh

- `zsh Tools/autoswitch/check.sh` đạt 169/169 Telex, 14/14 Simple Telex 1, 14/14 Simple Telex 2 và 20/20 ca hồi quy. Golden snapshots, undo, driver parity, hiệu năng và các mô phỏng đều đạt. Bài đo dùng dữ liệu nghiên cứu riêng được bỏ qua vì bộ dữ liệu đó không có trên máy.
- `cmake -S Windows -B Windows/build/host-check -DCMAKE_BUILD_TYPE=Release` và `cmake --build Windows/build/host-check --parallel 4` build thành công engine và công cụ test trên macOS. Luồng `check.ps1` chạy thành công với các binary host dưới PowerShell 7, gồm thử đường dẫn build có dấu cách.
- Cross-build `cmake --build <build-dir> --target envispeed envispeed_livetest` thành công cho x64 và ARM64 bằng Clang/LLD, Windows SDK 10.0.26100 và trình biên dịch resource trong thư mục tạm. Đối chiếu PE machine, version `0.1.1 (2)`, manifest, 8 kích thước icon, WAV/Emoji.json và import table qua `llvm-objdump -p`. Hai EXE không import DLL Visual C++ Redistributable.
- Đọc cú pháp PowerShell, parse YAML/XML, chạy `actionlint .github/workflows/windows.yml` và `git diff --check`. Đối chiếu WAV và TSV live test theo byte với upstream. TSV giữ dấu cách ở cuối ô vì đó là phím và kết quả mong đợi.
- Chạy `package.ps1` trên host với ISCC giả lập và PE thật để kiểm tra tên đầu ra, phát hiện kiến trúc, ZIP, ghi đè khi build lại, dọn staging và báo lỗi khi trình biên dịch trả mã khác 0. Version resource được đọc riêng từ PE vì .NET trên macOS không đọc metadata của PE native.

## Kiểm tra trên Windows

Chạy `Windows/check.ps1` rồi `Windows/package.ps1` từ Developer PowerShell theo README. Host macOS chưa chạy MSVC/ISCC native, chưa kiểm tra cài, nâng cấp, gỡ, hiển thị UI hoặc keyboard hook trên Windows. Bản đóng gói chưa ký Authenticode. CI sẽ chạy trên Windows sau khi source được push.

Trên desktop Windows, mở app, thử Alt+Z trong Notepad rồi chạy `Windows\Tests\run_livetest.cmd` theo thiết lập trong README. Kiểm tra Start Menu, bật/tắt chạy lúc đăng nhập, cài lại và gỡ.

## Kiểm thử native tiếp theo

Ngày 2026-11-06, nhánh `codex/windows-testing` đã build/test/package x64 và ARM64 trên CI, chạy lại đầy đủ `check.ps1` với binary CI trên Windows 10 Pro x64 và đạt 29/29 ca qua keyboard hook thực tế. Xem [báo cáo, nhật ký và phạm vi chưa kiểm tra](WINDOWS-10-TEST-2026-11-06.md).
