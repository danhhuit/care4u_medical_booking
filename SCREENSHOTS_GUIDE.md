# 📸 Hướng Dẫn Chụp Screenshots - Care4U Medical Booking

## Tổng Quan

Hướng dẫn này giúp bạn chụp toàn bộ screens của ứng dụng Care4U và lưu vào folder `/screenshots` với tên gọi có hệ thống.

---

## 🛠️ Chuẩn Bị

### Yêu Cầu

1. Flutter app đang chạy trên Android emulator hoặc device
2. Chạy lệnh: `flutter run`
3. ADB được cài đặt và kết nối

### Cấu Hình Android Emulator

- **API Level**: 21+
- **Resolution**: 1080x1920 (optimal cho screenshots)
- **RAM**: 2GB+

---

## 📱 Danh Sách Screens Cần Chụp

### Phase 1: Authentication (3 screens)

| ID  | Tên             | Mô Tả                       | Cách Chạy             |
| --- | --------------- | --------------------------- | --------------------- |
| 01  | Splash Screen   | Logo & thông điệp chào mừng | App vừa khởi động     |
| 02  | Login Screen    | Đăng nhập bằng phone        | Logout > Login        |
| 03  | Register Screen | Đăng ký tài khoản mới       | Khác không có account |

### Phase 2: Home & Navigation (4 screens)

| ID  | Tên            | Mô Tả              | Cách Chạy          |
| --- | -------------- | ------------------ | ------------------ |
| 04  | Home Screen    | Trang chủ chính    | Tap Home tab       |
| 05  | Drawer Menu    | Menu side drawer   | Tap Menu icon      |
| 06  | Search Results | Kết quả tìm bác sĩ | Tap search bar     |
| 07  | Quick Actions  | Grid tác vụ nhanh  | Scroll home screen |

### Phase 3: Doctors (5 screens)

| ID  | Tên              | Mô Tả                | Cách Chạy            |
| --- | ---------------- | -------------------- | -------------------- |
| 08  | Doctors List     | Danh sách bác sĩ     | Tap "Doctors" tab    |
| 09  | Filter Doctors   | Lọc theo chuyên khoa | Tap filter icon      |
| 10  | Doctor Detail    | Chi tiết bác sĩ      | Tap bác sĩ bất kỳ    |
| 11  | Doctor Reviews   | Đánh giá bác sĩ      | Scroll doctor detail |
| 12  | Book Appointment | Form đặt lịch        | Tap "Book Now"       |

### Phase 4: Appointments (5 screens)

| ID  | Tên                   | Mô Tả              | Cách Chạy              |
| --- | --------------------- | ------------------ | ---------------------- |
| 13  | Appointments List     | Danh sách lịch hẹn | Tap "Appointments" tab |
| 14  | Upcoming Appointments | Lịch sắp tới       | Tab "Upcoming"         |
| 15  | Appointment Detail    | Chi tiết lịch hẹn  | Tap lịch hẹn bất kỳ    |
| 16  | Map Booking           | Bản đồ chọn vị trí | Trong form đặt lịch    |
| 17  | Reschedule            | Chỉnh sửa lịch hẹn | Tap "Reschedule"       |

### Phase 5: Medical Info (4 screens)

| ID  | Tên                 | Mô Tả               | Cách Chạy         |
| --- | ------------------- | ------------------- | ----------------- |
| 18  | Medical Records     | Hồ sơ y tế          | Tap "Medical" tab |
| 19  | Record Detail       | Chi tiết hồ sơ      | Tap record bất kỳ |
| 20  | Prescriptions       | Danh sách đơn thuốc | Scroll records    |
| 21  | Prescription Detail | Chi tiết đơn thuốc  | Tap đơn bất kỳ    |

### Phase 6: Store & Shopping (4 screens)

| ID  | Tên            | Mô Tả              | Cách Chạy         |
| --- | -------------- | ------------------ | ----------------- |
| 22  | Store Products | Danh sách sản phẩm | Tap "Store" tab   |
| 23  | Product Filter | Lọc sản phẩm       | Tap categories    |
| 24  | Product Detail | Chi tiết sản phẩm  | Tap sản phẩm      |
| 25  | Shopping Cart  | Giỏ hàng           | Sau thêm sản phẩm |

### Phase 7: Payments & Wallet (4 screens)

| ID  | Tên                 | Mô Tả             | Cách Chạy       |
| --- | ------------------- | ----------------- | --------------- |
| 26  | Wallet Screen       | Ví điện tử        | Tap wallet icon |
| 27  | Top Up Wallet       | Nạp tiền          | Tap "Top Up"    |
| 28  | VietQR Payment      | Thanh toán QR     | Tap QR payment  |
| 29  | Transaction History | Lịch sử giao dịch | Tap history     |

### Phase 8: Social Features (4 screens)

| ID  | Tên           | Mô Tả              | Cách Chạy             |
| --- | ------------- | ------------------ | --------------------- |
| 30  | Chat Rooms    | Phòng chat         | Tap "Chat" tab        |
| 31  | Chat Detail   | Chi tiết chat      | Tap room bất kỳ       |
| 32  | Notifications | Thông báo          | Tap notification icon |
| 33  | Reviews List  | Danh sách đánh giá | Tap "Reviews"         |

### Phase 9: User Profile (4 screens)

| ID  | Tên          | Mô Tả               | Cách Chạy        |
| --- | ------------ | ------------------- | ---------------- |
| 34  | User Profile | Hồ sơ cá nhân       | Tap profile icon |
| 35  | Edit Profile | Chỉnh sửa thông tin | Tap "Edit"       |
| 36  | Settings     | Cài đặt             | Tap "Settings"   |
| 37  | Dark Mode    | Chế độ tối          | Settings > Theme |

### Phase 10: Admin (2 screens)

| ID  | Tên             | Mô Tả              | Cách Chạy       |
| --- | --------------- | ------------------ | --------------- |
| 38  | Admin Dashboard | Dashboard          | Đăng nhập admin |
| 39  | Admin Users     | Quản lý người dùng | Tap "Users"     |

---

## 🎥 Cách Chụp Screenshots

### Phương Pháp 1: Sử dụng ADB (Tự Động)

```bash
# Chụp 1 ảnh
adb shell screencap -p /sdcard/screenshot.png
adb pull /sdcard/screenshot.png ./screenshots/

# Đổi tên file
ren screenshot.png 01_splash_screen.png
```

### Phương Pháp 2: Sử dụng Flutter Screenshot Command

```bash
# Trong flutter run terminal, nhấn 's' để chụp
# Output: screenshot_01.png (auto trong project root)
```

### Phương Pháp 3: Sử dụng Android Studio

1. Mở Android Emulator
2. Click **...** (More) → **Screenshot**
3. Save vào folder `/screenshots`
4. Rename theo format

### Phương Pháp 4: Manual từ Device

1. Nhấn **Power + Volume Down** (Android)
2. Tìm ảnh trong gallery
3. Copy qua USB đến folder `/screenshots`

---

## 📋 Script Chụp Tự Động (Windows)

Tạo file `capture_screenshots.bat`:

```batch
@echo off
setlocal enabledelayedexpansion

set SCREENSHOTS_DIR=screenshots

if not exist %SCREENSHOTS_DIR% mkdir %SCREENSHOTS_DIR%

REM Danh sách các lượt chụp
for /l %%i in (1,1,39) do (
    echo Capturing screenshot %%i...
    set /a num=%%i
    if !num! lss 10 (
        set filename=0!num!_screen.png
    ) else (
        set filename=!num!_screen.png
    )

    adb shell screencap -p /sdcard/!filename!
    adb pull /sdcard/!filename! %SCREENSHOTS_DIR%\!filename!
    adb shell rm /sdcard/!filename!

    echo Screenshot !filename! captured
    timeout /t 2 /nobreak
)

echo All screenshots captured successfully!
pause
```

### Cách Chạy Script

```bash
# Di chuyển vào project root
cd d:\mobile\project\care4u_medical_booking

# Chạy script
capture_screenshots.bat
```

---

## 📱 Tên File Chuẩn

```
Format: NN_screen_name.png

Ví dụ:
- 01_splash_screen.png
- 02_login_screen.png
- 03_register_screen.png
- 04_home_screen.png
- 05_drawer_menu.png
- 06_search_results.png
- ... và cứ thế
```

---

## 🗂️ Cấu Trúc Folder Screenshots

```
screenshots/
├── 01_splash_screen.png
├── 02_login_screen.png
├── 03_register_screen.png
├── 04_home_screen.png
├── 05_drawer_menu.png
├── 06_search_results.png
├── 07_quick_actions.png
├── 08_doctors_list.png
├── 09_filter_doctors.png
├── 10_doctor_detail.png
├── 11_doctor_reviews.png
├── 12_book_appointment.png
├── 13_appointments_list.png
├── 14_appointments_upcoming.png
├── 15_appointment_detail.png
├── 16_map_booking.png
├── 17_reschedule.png
├── 18_medical_records.png
├── 19_record_detail.png
├── 20_prescriptions.png
├── 21_prescription_detail.png
├── 22_store_products.png
├── 23_product_filter.png
├── 24_product_detail.png
├── 25_shopping_cart.png
├── 26_wallet_screen.png
├── 27_top_up_wallet.png
├── 28_vietqr_payment.png
├── 29_transaction_history.png
├── 30_chat_rooms.png
├── 31_chat_detail.png
├── 32_notifications.png
├── 33_reviews_list.png
├── 34_user_profile.png
├── 35_edit_profile.png
├── 36_settings.png
├── 37_dark_mode.png
├── 38_admin_dashboard.png
└── 39_admin_users.png
```

---

## 🔄 Quy Trình Chi Tiết

### Step 1: Khởi Động App

```bash
flutter run
```

### Step 2: Đợi App Khởi Động Hoàn Toàn

- Chờ Splash Screen biến mất
- Chờ Home Screen load

### Step 3: Chụp Splash Screen

- App vừa khởi động = Splash Screen
- Chụp ngay khi thấy

### Step 4: Đăng Nhập

- Tap button đăng nhập
- Nhập số điện thoại (test: 0123456789)
- Nhập mật khẩu
- Chụp Login & Register screens

### Step 5: Chụp Home Screens

- Chụp Home screen
- Tap menu icon → chụp Drawer
- Tap search → chụp Search

### Step 6: Điều Hướng Qua Tabs

- Tap "Doctors" tab → chụp danh sách
- Tap một bác sĩ → chụp detail
- Tap "Book Now" → chụp form
- Chọn ngày/giờ → chụp form + map

### Step 7: Lặp Lại cho Mỗi Tab

- Medical tab → chụp records
- Store tab → chụp products
- Chat tab → chụp messages
- Profile tab → chụp thông tin

### Step 8: Quay Lại Home

- Tap Home tab
- Scroll xuống → chụp các section khác

---

## 💡 Tips & Tricks

### Để Chụp Đẹp

1. **Loại bỏ notifications**: Settings > Notifications > Off
2. **Dùng device resolution chuẩn**: 1080x1920 pixels
3. **Chụp khi UI hoàn toàn load**: Chờ 2-3 giây sau navigation
4. **Sử dụng good lighting**: Không có shadow hoặc glare

### Để Dễ Rename

1. Chụp theo thứ tự từ 01-39
2. Dùng batch rename tool nếu cần
3. Đặt tên theo feature (auth, home, doctors, etc.)

### Nếu Emulator Lag

1. Giảm resolution xuống 720x1280
2. Giảm RAM allocation
3. Khóa các ứng dụng không cần
4. Dùng x86_64 emulator thay vì ARM

---

## ✅ Checklist Hoàn Thành

- [ ] Tất cả 39 screenshots đã chụp
- [ ] Tên file theo format NN_screen_name.png
- [ ] Lưu trong folder /screenshots
- [ ] Mỗi ảnh 1080x1920 pixels
- [ ] Không có blur hoặc artifacts
- [ ] Đã xem lại tất cả ảnh
- [ ] Organize screenshots trong README

---

## 🚀 Automation Script (Advanced)

### Python Script để Chụp & Rename Tự Động

```python
#!/usr/bin/env python3
import os
import subprocess
import time
from datetime import datetime

class ScreenshotCapture:
    def __init__(self):
        self.screenshots_dir = "screenshots"
        self.counter = 1

    def ensure_dir(self):
        """Tạo folder screenshots nếu chưa tồn tại"""
        if not os.path.exists(self.screenshots_dir):
            os.makedirs(self.screenshots_dir)

    def capture(self, name):
        """Chụp 1 screenshot"""
        filename = f"{self.counter:02d}_{name}.png"
        filepath = os.path.join(self.screenshots_dir, filename)

        # Chụp via ADB
        adb_cmd = f"adb shell screencap -p /sdcard/{filename}"
        os.system(adb_cmd)

        # Pull về local
        pull_cmd = f"adb pull /sdcard/{filename} {filepath}"
        os.system(pull_cmd)

        # Xóa từ device
        os.system(f"adb shell rm /sdcard/{filename}")

        print(f"✓ Captured: {filename}")
        self.counter += 1
        time.sleep(2)

    def run(self):
        """Chạy quy trình chụp"""
        self.ensure_dir()

        screens = [
            "splash_screen",
            "login_screen",
            "register_screen",
            "home_screen",
            "drawer_menu",
            "search_results",
            "quick_actions",
            "doctors_list",
            "filter_doctors",
            "doctor_detail",
            "doctor_reviews",
            "book_appointment",
            "appointments_list",
            "appointments_upcoming",
            "appointment_detail",
            "map_booking",
            "reschedule",
            "medical_records",
            "record_detail",
            "prescriptions",
            "prescription_detail",
            "store_products",
            "product_filter",
            "product_detail",
            "shopping_cart",
            "wallet_screen",
            "top_up_wallet",
            "vietqr_payment",
            "transaction_history",
            "chat_rooms",
            "chat_detail",
            "notifications",
            "reviews_list",
            "user_profile",
            "edit_profile",
            "settings",
            "dark_mode",
            "admin_dashboard",
            "admin_users"
        ]

        for screen in screens:
            input(f"Press Enter to capture {screen}...")
            self.capture(screen)

        print("\n✓ All screenshots captured successfully!")

if __name__ == "__main__":
    capture = ScreenshotCapture()
    capture.run()
```

### Chạy Python Script

```bash
python capture_screenshots.py
```

---

## 📞 Hỗ Trợ

Nếu gặp vấn đề:

1. Kiểm tra ADB kết nối: `adb devices`
2. Kiểm tra Flutter version: `flutter --version`
3. Kiểm tra emulator running: `adb shell getprop ro.product.model`
4. Restart emulator/app nếu cần

---

**Last Updated**: 2026-06-17  
**Total Screens to Capture**: 39  
**Estimated Time**: 30-45 phút
