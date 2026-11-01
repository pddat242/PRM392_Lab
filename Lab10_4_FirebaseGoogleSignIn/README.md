# Lab 10.4 – Firebase Google Sign-In

Ứng dụng Flutter đăng nhập Google qua Firebase Authentication. Sau khi đăng nhập, màn hình hồ sơ hiển thị ảnh, tên, email và Firebase UID. Đăng xuất sẽ kết thúc phiên Firebase và Google. Project hỗ trợ Android và Chrome sau khi cấu hình Firebase cho nền tảng tương ứng.

## Cấu hình Firebase

Ứng dụng cần Firebase project và file cấu hình Android riêng của bạn trước khi chạy:

1. Tạo hoặc mở một project tại [Firebase Console](https://console.firebase.google.com/).
2. Thêm Android app với package name chính xác:

   ```text
   com.example.lab10_4_firebasegooglesignin
   ```

3. Lấy SHA-1 debug của app. Trong PowerShell, từ thư mục project:

   ```powershell
   cd android
   .\gradlew.bat signingReport
   ```

   Sao chép SHA-1 ở biến thể `debug` vào Android app trong **Firebase Console → Project settings → Your apps → SHA certificate fingerprints**.

4. Trong **Firebase Console → Authentication → Sign-in method**, bật **Google** và chọn support email.
5. Tải `google-services.json` của Android app vừa cấu hình và đặt vào:

   ```text
   android/app/google-services.json
   ```

   File cấu hình này được tạo riêng cho Firebase project của bạn và cần có trước khi build Android.

## Cấu hình web cho Chrome

1. Trong cùng Firebase project, thêm một **Web app**.
2. Bật Google provider như bước trên. Trong **Authentication → Settings → Authorized domains**, đảm bảo có `localhost`.
3. Cài Firebase CLI, đăng nhập và cài FlutterFire CLI nếu máy chưa có:

   ```powershell
   npm install -g firebase-tools
   firebase login
   dart pub global activate flutterfire_cli
   ```

4. Từ thư mục `Lab10_4_FirebaseGoogleSignIn`, chạy:

   ```powershell
   flutterfire configure --platforms=android,web
   ```

   Chọn Firebase project và các app Android/Web đã đăng ký. Lệnh này tạo `lib/firebase_options.dart`, file được `main.dart` dùng để khởi tạo Firebase trên Chrome. Android vẫn cần file `google-services.json` ở bước trước.

5. Khởi chạy trên Chrome:

   ```powershell
   flutter run -d chrome
   ```

## Chạy ứng dụng

Chạy trên Android emulator có Google Play hoặc thiết bị Android có Google Play Services:

```powershell
flutter pub get
flutter run
```

Đăng nhập bằng một Google account. Không cần test account riêng. Với Chrome, hoàn thành mục cấu hình web trước khi chạy. iOS cần Firebase app và cấu hình URL scheme riêng.

## Luồng chính

- `AuthGate` theo dõi `FirebaseAuth.authStateChanges()` để mở màn hình đăng nhập hoặc hồ sơ.
- `AuthService.signInWithGoogle()` lấy Google ID token rồi đổi thành Firebase credential.
- Hồ sơ hiển thị thông tin user trả về từ Firebase Authentication.
- Đăng xuất gọi cả `FirebaseAuth.signOut()` và `GoogleSignIn.signOut()`.
