# Kiểm thử Windows ngày 2026-11-06

Nhánh: `codex/windows-testing`. Source được build và kiểm tra: `0f219c1a6e6a42f67ca486802395dd2a89e5302a`, phiên bản Envispeed 0.1.1 (2).

## Môi trường và cách chạy

- Máy thử thực tế: Windows 10 Pro x64, build 19045.
- Máy chưa có Visual Studio, Windows SDK, CMake hoặc Ninja. Build MSVC và đóng gói chạy trên GitHub Actions; các binary x64 từ chính lần chạy đó được tải về máy để kiểm thử engine và keyboard hook.
- [Workflow của nhánh](https://github.com/chequanghuyca/envispeed/actions/runs/42197336151): cả x64 và ARM64 thành công, có Setup, ZIP portable và bộ công cụ kiểm thử.
- Không thay đổi engine, dữ liệu từ điển, quy tắc gõ hoặc mã ứng dụng. Nhánh bổ sung `check.ps1 -SkipBuild`, artifact công cụ kiểm thử và hướng dẫn dùng chúng.

## Kết quả

| Phạm vi | Kết quả |
| --- | --- |
| Build MSVC, kiểm thử và đóng gói trên CI x64 | Đạt |
| Build MSVC, kiểm thử và đóng gói trên CI ARM64 | Đạt |
| Telex mặc định trên máy Windows 10 | 169/169 |
| Simple Telex 1 và 2 trên máy Windows 10 | 14/14 mỗi kiểu |
| Lỗi hồi quy đã ghi nhận | 20/20 |
| Bốn golden snapshots | Giữ nguyên, tổng 20.567 dòng |
| Undo sau tự sửa, chuyển ngôn ngữ và click | Đạt |
| Đối chiếu output driver với simulator | Trùng khớp |
| Hiệu năng trên 238.532 phím | Trung bình 585 ns; p99.9 6.600 ns; đạt ngưỡng 1.000 / 20.000 ns |
| Gõ qua keyboard hook thực tế trên Windows 10 x64 | 29/29 |

Live test dùng `envispeed_livetest.exe` mở một cửa sổ EDIT riêng, gửi phím bằng `SendInput`, rồi đọc lại nội dung để so sánh với `Windows/Tests/cases.tsv`. Các ca bao gồm Telex, chuyển Việt/Anh hai chiều, sửa theo ngữ cảnh, Alt+Z, hoàn tác bằng Backspace, tiếp tục gõ sau hoàn tác, tên biến, chữ số, numpad, Home và Caps Lock. Từng ca kiểm tra focus trước và trong khi gõ.

Đã chạy 29 ca một lần với portable từ `main` và một lần nữa với portable được build từ nhánh `0f219c1`; cả hai đều đạt. Nhật ký bên dưới là lần chạy cuối với binary của nhánh.

Các chỉ số sai từ trong golden corpus vẫn là 1 (chat), 7 (chat có lỗi gõ), 9 (synthetic), bằng baseline. Kết quả golden thể hiện hành vi ổn định trên dữ liệu kiểm thử, không đo độ chính xác tổng quát trong mọi ứng dụng.

## Tái hiện

Từ checkout đúng commit, tải hai artifact x64 của workflow trên:

- `Envispeed-windows-test-tools-x64`: giải nén vào `Windows/build/`, giữ cấu trúc `tools/` và `App/`.
- `Envispeed-windows-x64`: giải nén ZIP portable và mở `Envispeed.exe`.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File Windows/check.ps1 -SkipBuild
Windows\Tests\run_livetest.cmd
```

Live test cần app đang chạy với thiết lập Telex mặc định, bố cục US, Num Lock bật, Caps Lock tắt và cửa sổ test giữ focus. Nhật ký thực tế:

- [Kiểm thử engine trên Windows 10](windows-10-x64-engine.log)
- [29 ca keyboard hook với portable của nhánh](windows-10-x64-live.log)

## Phần chưa kiểm tra

- Chưa thử cài, nâng cấp hoặc gỡ bằng Setup; CI đã tạo Setup và portable thành công.
- Chưa chạy giao diện hoặc keyboard hook trên máy ARM64. ARM64 đã build và chạy các kiểm thử engine trên runner Windows ARM64.
- Công cụ chụp cửa sổ trả `FrameArrived timed out: timed out waiting on channel` và `window capture timed out: timed out waiting on channel`. Có thể đọc cây accessibility của onboarding, nhưng chưa xác minh bố cục, màu sắc hoặc ảnh chụp giao diện trong phiên này.
- Chưa chạy bộ nghiên cứu riêng hoặc kiểm thử tương thích trên từng ứng dụng như Office, trình duyệt và terminal.

Bản portable x64 của nhánh được để chạy tại `dist/windows/branch/portable/Envispeed.exe` để tiếp tục thử thủ công.
