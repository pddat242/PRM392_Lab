# Lab 10.5 – Local Notifications

Ứng dụng Flutter minh họa local notification: xin quyền thông báo, bấm nút gửi thử và kiểm tra thông báo trong notification tray. Project dùng `flutter_local_notifications` và hỗ trợ Android cùng Chrome.

## Chạy ứng dụng

Từ thư mục `Lab10_5_Notification`:

```powershell
flutter pub get
flutter run -d chrome
```

Trên Chrome, bấm **Request notification permission** và cho phép localhost gửi thông báo. Sau đó bấm **Send test notification**. Trình duyệt chỉ cho hỏi quyền từ thao tác bấm của người dùng.

Để kiểm tra theo yêu cầu Android 13+, khởi chạy trên Android emulator API 33+ hoặc điện thoại Android:

```powershell
flutter devices
flutter run -d <device-id>
```

Chấp nhận quyền thông báo khi được hỏi, bấm **Send test notification**, rồi xem notification tray của Android. Trên Android cũ hơn API 33, thông báo thường được cho phép mặc định.

## Phần đã làm

- Khởi tạo plugin và kênh Android `Lab 10.5 Demo`.
- Xin quyền runtime trên Android 13+.
- Xin quyền từ nút người dùng trên Chrome.
- Gửi thông báo thử bằng thao tác thủ công.
- Hiển thị trạng thái quyền và lỗi để dễ kiểm tra khi demo.

Android build dùng `compileSdk 37`, Java 17 và core library desugaring theo yêu cầu của phiên bản plugin đã khai báo trong `pubspec.yaml`.
