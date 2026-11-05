# Envispeed — tách nhận diện và lịch sử repository

Ngày: 2026-11-06 (Asia/Ho_Chi_Minh)

## Yêu cầu đã chốt

Giữ bộ gõ và các tính năng đang hoạt động tốt. Làm sạch lịch sử Git, remote cũ và tên kỹ thuật để repository tập trung vào Envispeed; không viết lại engine. Giấy phép và bản quyền thành phần được giữ ở mục Pháp lý và các header bắt buộc.

## Phạm vi

1. Sao lưu đầy đủ mã nguồn/lịch sử trước khi làm sạch.
2. Đổi đồng bộ tên app, bridge, notification, C++ driver và biến môi trường công cụ sang Envispeed; giữ nguyên thuật toán và dữ liệu.
3. About chỉ hiển thị nhận diện sản phẩm/người duy trì, có nút mở thông tin pháp lý riêng.
4. Chuyển source tham khảo ngoài macOS và các publisher chưa dùng ra bản sao ngoài workspace; giữ App/, Engine/, Tools/ và bộ kiểm thử đang dùng.
5. Build bản kiểm tra riêng, chạy bộ engine tests và xác minh dữ liệu/golden không đổi.
6. Khởi tạo lịch sử Git độc lập của repository Envispeed, chỉ có origin của người dùng. Dùng force-with-lease với SHA đã xác minh để thay nhánh main; không ghi đè thay đổi mới của người khác.
7. Mở lại app macOS đã kiểm tra; chưa tạo DMG, không cài dependency mới.

## Bảo toàn và rollback

Bản sao ngoài workspace: `/Volumes/SSD/envispeed-backups/2026-11-06-before-git-cleanup/`, gồm Git bundle, source tar, source tham khảo và bản thử viết mới đã dừng. Không đưa bản thử viết mới vào repository hay ứng dụng.

Giữ toàn bộ quy tắc, dữ liệu nhận diện, corpus và golden fixtures. Chỉ đổi định danh; không đổi kiến trúc hoặc quy tắc gõ.

## Kết quả

Xem SUMMARY.md để biết file/screen, lệnh kiểm tra và trạng thái cuối.
