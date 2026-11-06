# Đưa Envispeed lên Windows

Ngày 2026-11-06 (Asia/Ho_Chi_Minh)

1. Lấy app Win32, tài nguyên, test và cấu hình đóng gói từ Vikey main `350efb25f49f1462814f69532c55c6e80ab4eb90`. Dùng engine C++ đã có trong Envispeed.
2. Áp dụng nhận diện Envispeed vào UI, metadata, bộ cài, dữ liệu và khởi động cùng Windows. Giữ thông báo bản quyền và nguồn dữ liệu.
3. Áp dụng chính sách của bản macOS cho liên kết phát hành, cài đặt riêng và báo cáo lỗi lưu trên máy.
4. Cung cấp lệnh build, test, tạo bộ cài và bản portable. Thêm CI Windows x64 và ARM64 lưu artifact để kiểm tra sau khi push.
5. Đối chiếu thay đổi với upstream và chạy các bước kiểm tra có thể thực hiện trên host. Ghi rõ các bước cần chạy trên Windows.
