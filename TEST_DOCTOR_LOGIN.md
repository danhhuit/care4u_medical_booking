# 🧪 HƯỚNG DẪN TEST ĐĂNG NHẬP BÁC SĨ

## 📊 Tài Khoản Test

### BS. Nguyễn Văn An (Tim Mạch)

```
Số điện thoại: 0912345678
Email: bsnguyen@care4u.vn
Mã BS: d1
Mật khẩu: 123456
Bệnh viện: BV Chợ Rẫy
```

### BS. Trần Thị Bình (Nhi Khoa)

```
Số điện thoại: 0923456789
Email: bstran@care4u.vn
Mã BS: d2
Mật khẩu: 123456
Bệnh viện: BV Nhi Đồng 1
```

### BS. Lê Trọng Chung (Thần Kinh)

```
Số điện thoại: 0934567890
Email: bsle@care4u.vn
Mã BS: d3
Mật khẩu: 123456
Bệnh viện: BV 115
```

### BS. Phạm Thị Dung (Da Liễu)

```
Số điện thoại: 0945678901
Email: bspham@care4u.vn
Mã BS: d4
Mật khẩu: 123456
Bệnh viện: BV Da Liễu TP.HCM
```

---

## 🎯 QUY TRÌNH TEST

### **Bước 1: Khởi Động Ứng Dụng**

```bash
# Mở terminal tại thư mục project
cd d:\mobile\project\care4u_medical_booking

# Chạy ứng dụng
flutter run
```

### **Bước 2: Điều Hướng Đến Màn Hình Đăng Nhập Bác Sĩ**

- Splash Screen hiện lên
- Tìm nút "Đăng Nhập Bác Sĩ" hoặc "Doctor Login"
- Bấm vào nút đó

### **Bước 3: Điền Thông Tin**

| Trường        | Giá Trị    | Ghi Chú              |
| ------------- | ---------- | -------------------- |
| Số điện thoại | 0912345678 | 10 chữ số, bắt đầu 0 |
| Mã BS         | d1         | Mã định danh nghề    |
| Mật khẩu      | 123456     | 6 chữ số             |

### **Bước 4: Bấm "Đăng Nhập"**

- Chờ vài giây để xử lý
- Nếu thành công → Thông báo "Đăng nhập thành công"
- Nếu thất bại → Thông báo "Sai thông tin đăng nhập"

---

## ✅ TEST CASES

### **TC1: Đăng Nhập Thành Công - BS Nguyễn Văn An**

```
📝 Đầu vào:
  - Số ĐT: 0912345678
  - Mã BS: d1
  - Mật khẩu: 123456

✅ Kết quả mong đợi:
  - Thông báo "Đăng nhập thành công"
  - Chuyển đến trang Home
  - Hiển thị "Chào BS. Nguyễn Văn An" (nếu có)
```

### **TC2: Đăng Nhập Thành Công - BS Trần Thị Bình**

```
📝 Đầu vào:
  - Số ĐT: 0923456789
  - Mã BS: d2
  - Mật khẩu: 123456

✅ Kết quả mong đợi:
  - Đăng nhập thành công
  - Chuyển Home
```

### **TC3: Mã BS Sai**

```
📝 Đầu vào:
  - Số ĐT: 0912345678
  - Mã BS: d2 (sai)
  - Mật khẩu: 123456

❌ Kết quả mong đợi:
  - Thông báo "Sai thông tin đăng nhập"
  - Không chuyển trang
```

### **TC4: Mật Khẩu Sai**

```
📝 Đầu vào:
  - Số ĐT: 0912345678
  - Mã BS: d1
  - Mật khẩu: 654321 (sai)

❌ Kết quả mong đợi:
  - Thông báo "Sai thông tin đăng nhập"
```

### **TC5: Số Điện Thoại Không Hợp Lệ**

```
📝 Đầu vào:
  - Số ĐT: 091234567 (9 chữ)
  - Mã BS: d1
  - Mật khẩu: 123456

❌ Kết quả mong đợi:
  - Thông báo "Số điện thoại không hợp lệ"
  - Không gửi form
```

### **TC6: Mật Khẩu Không Hợp Lệ**

```
📝 Đầu vào:
  - Số ĐT: 0912345678
  - Mã BS: d1
  - Mật khẩu: 12345 (5 chữ, cần 6)

❌ Kết quả mong đợi:
  - Thông báo "Mật khẩu không hợp lệ"
```

### **TC7: Dùng Email Thay Số Điện Thoại**

```
📝 Đầu vào:
  - Số ĐT: bsnguyen@care4u.vn (email)
  - Mã BS: d1
  - Mật khẩu: 123456

✅ Kết quả mong đợi:
  - Đăng nhập thành công
  - Hệ thống nhận email như tài khoản
```

### **TC8: Để Trống Trường Bắt Buộc**

```
📝 Đầu vào:
  - Số ĐT: (trống)
  - Mã BS: d1
  - Mật khẩu: 123456

❌ Kết quả mong đợi:
  - Thông báo "Vui lòng điền đủ thông tin"
```

---

## 🐛 TROUBLESHOOTING

### **Vấn Đề 1: Không Thấy Nút "Đăng Nhập Bác Sĩ"**

- ✅ Kiểm tra tệp `lib/app/router/app_router.dart`
- ✅ Kiểm tra tệp `lib/features/auth/presentation/screens/`
- ✅ Có thể cần thêm nút điều hướng trong login screen

### **Vấn Đề 2: Đăng Nhập Không Thành Công Mặc Dù Thông Tin Đúng**

- ✅ Kiểm tra Firebase đã được khởi tạo: `main.dart`
- ✅ Kiểm tra Mock Data đã được load: `MockData.init()`
- ✅ Kiểm tra tài khoản Firebase có tồn tại không

### **Vấn Đề 3: Lỗi "Số điện thoại không hợp lệ" Với Số Hợp Lệ**

- ✅ Kiểm tra regex validation trong `login_doctor_screen.dart`
- ✅ Đảm bảo nhập đúng 10 chữ số, bắt đầu 0

### **Vấn Đề 4: Hot Reload Không Cập Nhật**

```bash
# Sử dụng Hot Restart thay vì Hot Reload
# Trong terminal, nhấn:
R  # Hot Restart (thay vì r)
```

---

## 📱 TEST TRÊN THIẾT BỊ THỰC

### **Android Device**

```bash
# Kết nối USB và bật USB Debugging
flutter run

# Hoặc chỉ định thiết bị:
flutter devices  # Xem danh sách thiết bị
flutter run -d <device_id>
```

### **iOS Device**

```bash
# Cần cấu hình Xcode
flutter run
```

---

## 🔄 QUYỀN VỀ FIREBASE

Nếu Firebase Authentication bắt lỗi:

1. **Kiểm tra Firebase Console**
   - Vào https://console.firebase.google.com
   - Chọn project "care4u_medical_booking"
   - Vào Authentication → Users
   - Đảm bảo người dùng test đã được tạo

2. **Tạo Người Dùng Test Trong Firebase**

   ```
   Email: bsnguyen@care4u.vn
   Mật khẩu: 123456
   ```

3. **Bật Emulator Mode (Nếu Cần)**
   - Trong `main.dart`:
   ```dart
   await FirebaseAuth.instance.setSettings(
     appVerificationDisabledForTesting: true
   );
   ```

---

## 💡 TIPS TEST HIỆU QUẢ

1. **Dùng Hot Reload**
   - Sửa code → Bấm `r` → Thay đổi áp dụng ngay
   - Không cần khởi động lại ứng dụng

2. **Dùng Developer Tools**
   - `flutter run --debug` → Mở DevTools
   - Xem network requests, logs, widget tree

3. **Test Multiple Accounts**
   - Đăng nhập với tài khoản 1 → Home
   - Logout → Đăng nhập với tài khoản 2
   - Kiểm tra thông tin bác sĩ khác nhau

4. **Chụp Màn Hình / Video**
   - Chứng minh tính năng hoạt động
   - Hữu ích cho documentation

5. **Kiểm Tra Logs**

   ```bash
   # Xem tất cả logs
   flutter logs

   # Kiểm tra lỗi xác thực
   # Tìm "Login error:" hoặc "Doctor authentication"
   ```

---

## 📝 FORM KIỂM TRA KẾT QUẢ

| Test Case                       | Thực Hiện | Kết Quả         | Ghi Chú |
| ------------------------------- | --------- | --------------- | ------- |
| TC1: Đăng nhập BS Nguyễn Văn An | ☐         | ☐ Pass / ☐ Fail |         |
| TC2: Đăng nhập BS Trần Thị Bình | ☐         | ☐ Pass / ☐ Fail |         |
| TC3: Mã BS sai                  | ☐         | ☐ Pass / ☐ Fail |         |
| TC4: Mật khẩu sai               | ☐         | ☐ Pass / ☐ Fail |         |
| TC5: Số ĐT không hợp lệ         | ☐         | ☐ Pass / ☐ Fail |         |
| TC6: Dùng email                 | ☐         | ☐ Pass / ☐ Fail |         |
| TC7: Trường trống               | ☐         | ☐ Pass / ☐ Fail |         |

---

**✨ Sẵn sàng test!** Hãy làm theo hướng dẫn trên.
