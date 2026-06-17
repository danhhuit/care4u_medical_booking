# Care4U Medical Booking - Ứng dụng Đặt lịch Khám Bệnh Trực Tuyến

## 📱 Giới thiệu Ứng dụng

**Care4U Medical Booking** là một ứng dụng di động toàn diện, được phát triển bằng **Flutter** và có backend là **.NET**, cho phép bệnh nhân dễ dàng tìm kiếm, đặt lịch khám bệnh và quản lý hồ sơ y tế trực tuyến.

Ứng dụng cung cấp một nền tảng kết nối giữa bệnh nhân và các bác sĩ, trung tâm y tế, hỗ trợ thanh toán online, quản lý đơn thuốc, hồ sơ bệnh án và nhiều tính năng khác.

---

## ✨ Các Tính Năng Chính

### 1. **🔐 Xác thực & Đăng nhập**

- **Trang Splash**: Logo và thông điệp chào mừng
- **Đăng nhập**: Hỗ trợ đăng nhập bằng số điện thoại
- **Đăng ký**: Tạo tài khoản mới dễ dàng
- **Quên mật khẩu**: Khôi phục mật khẩu qua email

---

### 2. **🏠 Trang Chủ**

- **Trang Chủ Chính (Home Screen)**:
  - Tiêu đề chào mừng cá nhân hóa
  - Thanh tìm kiếm bác sĩ
  - Slider các tác vụ nhanh (Tìm bác sĩ, Mua thuốc, Chuyên khoa, Lịch hẹn, Hồ sơ sức khỏe, Đặt lịch)
  - Các dịch vụ nổi bật
  - Cập nhật trực tiếp từ API

**Phần Header**:

- Menu Drawer (Hamburger menu)
- Ví (Wallet)
- Thông báo (Notifications)
- Chat

---

### 3. **👨‍⚕️ Tìm Kiếm & Xem Bác Sĩ**

- **Danh sách bác sĩ** với:
  - Tên và chuyên khoa
  - Đánh giá sao (Rating)
  - Số lượng đánh giá
  - Hình ảnh đại diện
  - Kinh nghiệm
- **Lọc theo chuyên khoa**: Tim mạch, Nhi khoa, Thần kinh, Da liễu, v.v.
- **Tìm kiếm** theo tên bác sĩ
- **Thông tin chi tiết bác sĩ** bao gồm:
  - Tiểu sử
  - Bệnh viện/Trung tâm
  - Phí khám
  - Lịch làm việc

---

### 4. **📅 Đặt Lịch Khám**

- **Mục Lịch Hẹn**:
  - Hiển thị các lịch hẹn (Sắp tới, Đã hoàn thành, Đã hủy)
  - Tính năng Tab để lọc trạng thái
  - Thông tin chi tiết: Bác sĩ, Thời gian, Lý do khám

- **Đặt Lịch Mới**:
  - Chọn bác sĩ
  - Chọn ngày & giờ
  - Nhập lý do khám
  - Xác nhận thanh toán
  - Xem vị trí trên bản đồ

- **Chỉnh sửa Lịch**:
  - Chuyển đổi ngày giờ
  - Hủy lịch hẹn
  - Đánh giá sau khám

---

### 5. **💊 Đơn Thuốc (Prescriptions)**

- **Danh sách đơn thuốc**:
  - Mã đơn thuốc
  - Ngày kê đơn
  - Bác sĩ kê đơn
  - Danh sách thuốc
- **Chi tiết đơn thuốc**:
  - Các thuốc được kê
  - Liều dùng, cách dùng
  - Ghi chú thêm
  - Tình trạng (sẵn sàng/chưa sẵn sàng)

---

### 6. **📋 Hồ sơ Y Tế (Medical Records)**

- **Lịch sử khám bệnh**:
  - Chẩn đoán
  - Ngày khám
  - Bác sĩ khám
  - Triệu chứng & lý do khám
  - Phác đồ điều trị
  - Dấu hiệu sinh tồn
  - Mã ICD-10

- **Kết quả xét nghiệm**:
  - Loại xét nghiệm
  - Ngày xét
  - Kết quả chi tiết

---

### 7. **👤 Hồ sơ Cá Nhân & Cài Đặt**

- **Thông tin cá nhân**:
  - Tên, Ngày sinh
  - Giới tính
  - Địa chỉ
  - Số điện thoại
  - Email

- **Chỉnh sửa thông tin**:
  - Cập nhật hồ sơ
  - Thay đổi mật khẩu

- **Cài Đặt**:
  - Chế độ tối/sáng (Dark/Light mode)
  - Ngôn ngữ (Tiếng Việt/Tiếng Anh)
  - Thông báo
  - Đăng xuất

---

### 8. **💬 Trò Chuyện (Chat)**

- **Phòng chat** với bác sĩ:
  - Danh sách cuộc trò chuyện
  - Hiển thị tin nhắn chưa đọc
  - Thời gian tin nhắn cuối cùng

- **Chi tiết chat**:
  - Gửi/nhận tin nhắn
  - Hiển thị thời gian
  - Lịch sử cuộc trò chuyện

---

### 9. **⭐ Đánh Giá Bác Sĩ**

- **Danh sách lịch hẹn để đánh giá**:
  - Các lịch khám đã hoàn thành
  - Trạng thái "Đã đánh giá"

- **Ghi đánh giá**:
  - Chọn sao (1-5 sao)
  - Viết nhận xét
  - Gửi đánh giá

- **Xem đánh giá**:
  - Danh sách các lần đánh giá
  - Phản hồi từ bác sĩ (nếu có)

---

### 10. **🛒 Cửa Hàng & Sản Phẩm**

- **Danh sách sản phẩm**:
  - Thuốc, Thiết bị y tế, Sản phẩm chăm sóc
  - Giá tiền, Giảm giá
  - Hình ảnh sản phẩm
  - Đánh giá sao

- **Tìm kiếm & Lọc**:
  - Theo danh mục
  - Theo từ khóa
  - Sắp xếp theo giá

- **Giỏ hàng**:
  - Thêm/xóa sản phẩm
  - Thay đổi số lượng
  - Tính tổng giá
  - Tiến hành thanh toán

- **Lịch sử đơn hàng**:
  - Các đơn hàng đã mua
  - Trạng thái giao hàng

---

### 11. **💳 Ví & Thanh Toán**

- **Ví Điện Tử**:
  - Hiển thị số dư
  - Nạp tiền vào ví
  - Thanh toán qua VietQR

- **Lịch sử giao dịch**:
  - Danh sách các giao dịch
  - Chi tiết giao dịch
  - Thời gian & số tiền

- **Thanh toán**:
  - Xác nhận thanh toán
  - Chọn phương thức thanh toán
  - Mã QR thanh toán

---

### 12. **🔔 Thông Báo**

- **Danh sách thông báo**:
  - Thông báo lịch khám sắp tới
  - Xác nhận đặt lịch
  - Hủy lịch khám
  - Cập nhật đơn thuốc
  - Thông báo thanh toán
  - Các thông báo hệ thống khác

- **Đánh dấu đã đọc**:
  - Đánh dấu từng thông báo
  - Đánh dấu tất cả

---

### 13. **🏥 Chuyên Khoa**

- **Danh sách chuyên khoa**:
  - Mô tả chi tiết
  - Số bác sĩ
  - Xem danh sách bác sĩ chuyên khoa

---

### 14. **🗺️ Trung Tâm Y Tế**

- **Bản đồ tương tác**:
  - Vị trí trung tâm
  - Thông tin chi tiết
  - Liên hệ & địa chỉ

---

### 15. **👨‍💼 Quản Trị (Admin)**

- **Quản lý người dùng**:
  - Danh sách các tài khoản (Admin, Bác sĩ, Bệnh nhân)
  - Lọc theo vai trò
  - Khóa/Mở khóa tài khoản
- **Thống kê & Báo cáo**:
  - Biểu đồ doanh thu
  - Số lượng bệnh nhân
  - Số lượng bác sĩ

---

## 🏗️ Kiến Trúc Ứng Dụng

### Cấu Trúc Thư Mục

```
lib/
├── main.dart                          # Entry point
├── app/
│   ├── router/                        # Navigation routing
│   ├── theme/                         # Themes, colors, text styles
│   └── app.dart                       # Main app widget
├── core/
│   ├── api/                           # API service
│   ├── services/                      # Services (Firebase, Storage, etc.)
│   └── constants/                     # Constants & translations
├── features/
│   ├── auth/                          # Authentication
│   ├── home/                          # Home screen
│   ├── appointments/                  # Appointments management
│   ├── doctors/                       # Doctor listing & details
│   ├── prescriptions/                 # Prescriptions
│   ├── medical_records/               # Medical records
│   ├── patient_profile/               # Patient profile
│   ├── notifications/                 # Notifications
│   ├── chat/                          # Chat functionality
│   ├── reviews/                       # Doctor reviews
│   ├── store/                         # Online store
│   ├── payments/                      # Payments & wallet
│   ├── specialties/                   # Specialties
│   ├── health_center/                 # Health centers
│   └── admin/                         # Admin dashboard
├── shared/                            # Shared components
└── assests/                           # Assets & images
```

---

## 🔌 Công Nghệ & Dependencies

### Frontend (Flutter)

- **Flutter**: 3.38.8
- **Provider**: 6.1.2 - State management
- **Dio**: 5.7.0 - HTTP client
- **Firebase**: firebase_core, firebase_auth, cloud_firestore, firebase_messaging
- **Google Maps Flutter**: 2.16.0 - Map integration
- **URL Launcher**: 6.3.2 - Opening URLs
- **SQLite**: 2.3.3+1 - Local database
- **Geolocator**: 11.0.1 - GPS location
- **Intl**: 0.19.0 - Internationalization
- **FL Chart**: 0.70.2 - Charts & graphs

### Backend (.NET)

- **.NET** (ASP.NET Core)
- **Entity Framework Core** - ORM
- **SQL Server** - Database
- **Firebase Admin SDK** - Notifications

---

## 🚀 Tính Năng Tiên Tiến

### 1. **Real-time Notifications**

- Firebase Cloud Messaging (FCM)
- Push notifications cho lịch khám, đơn thuốc, tin nhắn

### 2. **Multi-language Support**

- Tiếng Việt (VI) & Tiếng Anh (EN)
- Dynamic language switching

### 3. **Dark/Light Mode**

- Hỗ trợ chế độ tối (Dark mode)
- Hỗ trợ chế độ sáng (Light mode)
- Tùy chọn tuân theo hệ thống

### 4. **Real-time Chat**

- Chat giữa bệnh nhân và bác sĩ
- Xem lịch sử tin nhắn

### 5. **Google Maps Integration**

- Xem vị trí trung tâm y tế
- Chọn địa điểm để đặt lịch

### 6. **Secure Payments**

- Tích hợp VietQR
- Thanh toán an toàn qua ví điện tử
- Lịch sử giao dịch đầy đủ

---

## 📱 Platform Support

- ✅ **Android**: API 21+ (Android 5.0+)
- ✅ **iOS**: iOS 12.0+
- ✅ **Web**: Chrome, Firefox, Safari (experimental)
- ✅ **Windows**: Desktop version
- ✅ **macOS**: Desktop version
- ✅ **Linux**: Desktop version

---

## 🎨 Giao Diện & UX

### Màu Sắc Chính

- **Primary**: `#2BB5A0` (Turquoise) - Màu chính của app
- **Secondary**: `#5C6BC0` (Indigo)
- **Success**: `#4CAF50` (Green)
- **Error**: `#F44336` (Red)
- **Warning**: `#FF9800` (Orange)

---

## 💻 Cách Chạy Dự Án

```bash
# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run

# Chạy trên Android emulator
flutter run -d emulator-5554

# Chạy trên device thật
flutter run

# Build APK release
flutter build apk --release

# Build iOS
flutter build ios --release

# Build Web
flutter build web --release
```

---

## 🔄 Quy Trình Đặt Lịch

```
Bệnh nhân tìm bác sĩ
    ↓
Xem chi tiết bác sĩ
    ↓
Chọn ngày/giờ & nhập lý do
    ↓
Thanh toán (nếu có phí)
    ↓
Xác nhận lịch hẹn
    ↓
Nhận thông báo trước khám
```

---

## 📊 Thống Kê Dự Án

- **Ngôn ngữ chính**: Dart (Flutter)
- **Total Lines of Code**: 10,000+ dòng
- **Features**: 15+ chức năng chính
- **Screens**: 30+ màn hình
- **Version**: 1.0.0
- **Status**: Active Development 🚀

---

**Last Updated**: 2026-06-17  
**Repository**: https://github.com/danhhuit/care4u_medical_booking  
**Branch**: develop
