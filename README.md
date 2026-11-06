<p align="center">
  <img src="design/Envispeed-logo.png" width="140" alt="Logo Envispeed: chữ e với vòng chuyển đổi Việt / Anh">
</p>
<h1 align="center">Envispeed</h1>
<p align="center"><strong>Gõ tự nhiên. Làm việc liền mạch.</strong><br>Bộ gõ Việt / Anh cho macOS và Windows, dành cho những ngày chuyển giữa code, tài liệu và hội thoại.</p>
<p align="center">macOS 13+ · Windows 10 x64 (1903+) / Windows 11 x64 và ARM64 · C++ · GPL-3.0 · Preview 0.1.1</p>

## Viết theo mạch suy nghĩ của bạn

Gõ Telex như thường lệ. Khi bạn chuyển giữa từ tiếng Việt và tiếng Anh, engine nhận diện ngữ cảnh để sửa từ và chuyển chế độ. Bạn vẫn có thể chọn ngôn ngữ bằng menu bar hoặc phím tắt (mặc định **⌥Z**).

- **Telex quen thuộc:** hỗ trợ Telex, Telex đơn giản 1/2 và hai cách đặt dấu `hoà` / `hòa`.
- **Việt / Anh trong một câu:** `treen` → `trên`, đồng thời nhận diện các từ tiếng Anh.
- **Dành cho công việc:** các trường hợp như `const`, `git push`, `obj.dir`, `my_var` được engine xử lý theo quy tắc có kiểm thử.
- **Nhớ ngữ cảnh:** ngôn ngữ theo ứng dụng; tùy chọn nhớ theo website cần quyền Automation của trình duyệt.
- **Chủ động hoàn tác:** bấm Delete ngay sau một lần tự sửa để hoàn tác.
- **Emoji song ngữ:** tìm bằng tiếng Việt / Anh, bật và đặt phím tắt trong Cài đặt.
- **Xử lý phím trên máy:** không cần tài khoản; bản macOS này không gửi crash report và không tự tải cập nhật.

Engine gõ, dữ liệu nhận diện và các quy tắc đã kiểm thử được giữ lại. Bản macOS local preview chưa phải DMG đã ký / notarize. Giấy phép và nguồn gốc thành phần được trình bày riêng trong [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md).

<p align="center"><img src="design/screenshots/settings-light.png" width="560" alt="Cửa sổ cài đặt Envispeed trên macOS"></p>

## Chạy trên Mac

Cần Xcode với macOS SDK đang được chọn qua `xcode-select`. Không cần cài package, XcodeGen hay thư viện bên ngoài cho lệnh chạy local:

```sh
zsh Tools/macos/build-local.sh --run
```

App được tạo ở `build/macos/Envispeed.app`, ký ad-hoc để chạy trên máy đang build. Để build lại, thoát Envispeed từ menu bar trước. Bản local chỉ build kiến trúc của máy hiện tại.

Lần đầu mở:

1. Chọn **Bắt đầu**, rồi **Mở Cài đặt hệ thống** trong onboarding.
2. Bật **Envispeed** tại **Quyền riêng tư & Bảo mật → Trợ năng (Accessibility)**.
3. Quay lại app để thử gõ và thiết lập phím tắt. Khi thử, chỉ bật một bộ gõ tiếng Việt để tránh xử lý phím chồng nhau.

Nếu chữ ký ad-hoc thay đổi sau khi build lại và macOS không nhận quyền cũ, xóa mục Envispeed cũ trong Trợ năng, rồi thêm lại đúng app ở đường dẫn build trên. Không cần vô hiệu hóa Gatekeeper hay SIP.

Định danh: `io.github.chequanghuyca.envispeed`. Cài đặt và dữ liệu Envispeed tách riêng; app không tự lấy lịch sử gõ hoặc cài đặt của ứng dụng khác. Ghi nhật ký gõ tắt mặc định, chỉ bật trong menu **Gỡ lỗi**; nếu bật, dữ liệu lưu tại `~/Library/Application Support/Envispeed/`.

## Build và đóng gói trên Windows

Cần Visual Studio 2022 (hoặc mới hơn) với workload **Desktop development with C++**, Windows SDK, CMake và Ninja. Dùng **Developer PowerShell** đã nạp MSVC cho kiến trúc đích. Chọn `amd64` cho x64 hoặc `arm64` cho ARM64. Khi chuyển kiến trúc, chọn thư mục build mới qua `-BuildDir` để tách CMake cache.

Từ thư mục gốc của repo, cài Python 3 có lệnh `python` trong PATH để chạy kiểm thử. Cần Inno Setup 6.3+ để tạo bộ cài:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Windows/check.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File Windows/package.ps1
```

`check.ps1` build Release, kiểm tra Telex, lỗi hồi quy, golden snapshots, undo, driver parity và hiệu năng. Nếu chỉ cần EXE, dùng `cmake -S Windows -B Windows/build -G Ninja -DCMAKE_BUILD_TYPE=Release` rồi `cmake --build Windows/build --target envispeed`.

- **EXE** nằm ở `Windows/build/App/Envispeed.exe`, liên kết tĩnh Visual C++ runtime.
- **Bộ cài và bản portable** nằm ở `dist/windows/`. Script đọc phiên bản và kiến trúc từ EXE. Nếu đổi thư mục build, truyền đường dẫn EXE qua `-Exe`. Nếu Inno Setup ở vị trí khác, truyền đường dẫn `ISCC.exe` qua `-Iscc`.
- **GitHub Actions** build và đóng gói x64/ARM64, lưu artifact trong lần chạy workflow **Windows**. Bản build từ script hiện chưa ký Authenticode.

Mở EXE, hoàn thành hướng dẫn rồi thử gõ trong Notepad và dùng **Alt+Z** để chuyển Việt/Anh. Để chạy bộ kiểm thử qua keyboard hook, giữ app đang chạy với cấu hình Telex mặc định, chuyển bố cục Windows sang US, bật Num Lock, tắt Caps Lock và chạy `Windows\Tests\run_livetest.cmd`. Để cửa sổ test giữ focus đến khi kết thúc. Thoát Envispeed từ khay hệ thống trước khi cài lại hoặc gỡ cài đặt.

Cấu hình lưu ở `HKCU\Software\Envispeed`. Nhật ký gõ tắt mặc định. Nhật ký khi bật và báo cáo lỗi lưu ở `%LOCALAPPDATA%\Envispeed`. Mục **Xem bản phát hành** mở GitHub Releases để tải thủ công.

## Kiểm thử

```sh
zsh Tools/autoswitch/check.sh
zsh -n Tools/macos/build-local.sh
codesign --verify --deep --strict build/macos/Envispeed.app
```

Bộ kiểm thử có các quy tắc gõ, lỗi đã báo, golden snapshots Việt / Anh, cursor / undo và ngưỡng hiệu năng. Bộ dữ liệu nghiên cứu riêng của upstream không đi kèm nên phần đánh giá đó được bỏ qua có thông báo.

Để chụp các màn hình thật của bản Debug mà không khởi động bộ đọc phím:

```sh
build/macos/Envispeed.app/Contents/MacOS/Envispeed -renderMainWindow /tmp/envispeed-light
build/macos/Envispeed.app/Contents/MacOS/Envispeed -renderMainWindow /tmp/envispeed-dark -renderDark YES
```

Thoát app đang mở trước khi chạy các lệnh chụp. Đường dẫn `/tmp` là nơi kiểm tra ảnh, không phải ảnh mockup.

## Source và phát hành

- `App/`: ứng dụng macOS SwiftUI và cầu nối Objective-C++.
- `Windows/`: ứng dụng Win32, công cụ kiểm thử và bộ cài Inno Setup.
- `Engine/`: engine gõ C++ dùng chung.
- `Tools/macos/`: build local và tạo các kích thước icon từ logo gốc.
- `project.yml`: cấu hình XcodeGen cho người đã có công cụ, target / scheme `Envispeed`. Signing phát hành sẽ được thiết lập sau.
- `.planning/envispeed-branding/`: phạm vi, kết quả kiểm tra và công việc còn lại.

Menu **Xem bản phát hành** mở [GitHub Releases](https://github.com/chequanghuyca/envispeed/releases). Menu **Gửi góp ý** mở [GitHub Issues](https://github.com/chequanghuyca/envispeed/issues). App không tự đính kèm nội dung gõ hay báo cáo lỗi.

Chưa cấu hình Developer ID, notarization hoặc update feed.

## Giấy phép và ghi nhận

Phân phối theo [GPL-3.0](LICENSE). Envispeed được tùy biến bởi **chequanghuyca** từ ngày **2026-11-06**. Thông báo bản quyền của các thành phần và nguồn dữ liệu được giữ trong [ACKNOWLEDGEMENTS.md](ACKNOWLEDGEMENTS.md) và các header bản quyền tương ứng. Menu **Giấy phép & thành phần** cho phép xem thông tin pháp lý trong app.
