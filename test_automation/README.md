# Care4U – Appium Test Suite (C# + NUnit)

## Cấu trúc dự án

```
test_automation/
└── Care4U.AppiumTests/
    ├── Care4U.AppiumTests.csproj   ← NuGet packages
    ├── appsettings.json            ← Cấu hình device, credentials
    ├── Helpers/
    │   ├── AppiumTestBase.cs       ← Base class: driver setup, tap, swipe, screenshot
    │   └── AppHelpers.cs          ← Helpers điều hướng, đăng nhập
    └── Tests/
        ├── AuthTests.cs           ← TC_AUTH_001 – TC_AUTH_040 (40 tests)
        ├── DoctorTests.cs         ← TC_DOC_001  – TC_DOC_035  (35 tests)
        ├── UITests.cs             ← TC_UI_001   – TC_UI_015   (15 tests)
        └── NFRTests.cs            ← TC_NFR_001  – TC_NFR_010  (10 tests)
                                                 Tổng: 100 testcase
```

## Điều kiện tiên quyết

| Công cụ | Yêu cầu | Kiểm tra |
|---|---|---|
| .NET 8 SDK | ✅ | `dotnet --version` |
| Node.js | ≥ 18 | `node -v` |
| Appium | 2.x | `appium --version` |
| Appium UiAutomator2 | bất kỳ | `appium driver list` |
| Android SDK / ADB | ✅ | `adb devices` |
| Android Emulator | Pixel 5 API 30+ | AVD Manager |
| Care4U app | Build release hoặc debug | Cài trên emulator |

## Cài đặt nhanh (nếu chưa có)

```powershell
# Appium + driver
npm install -g appium@latest
appium driver install uiautomator2

# Kiểm tra emulator
adb devices   # phải thấy emulator-5554
```

## Cấu hình (appsettings.json)

```json
{
  "Appium": {
    "ServerUrl": "http://127.0.0.1:4723",
    "DeviceName": "emulator-5554",     ← đổi nếu khác
    "AppPackage": "com.example.care4u_medical_booking"
  },
  "TestData": {
    "AdbPath": "D:\\Android\\Sdk\\platform-tools\\adb.exe"  ← đổi đường dẫn ADB
  }
}
```

> **Quan trọng**: Kiểm tra đường dẫn `AdbPath` và `DeviceName` khớp với emulator của bạn.

## Chạy test

### Tất cả 100 testcase
```powershell
cd d:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests
dotnet test --logger "console;verbosity=detailed"
```

### Chỉ chạy một nhóm
```powershell
# Nhóm AUTH
dotnet test --filter "FullyQualifiedName~AuthTests"

# Nhóm DOC
dotnet test --filter "FullyQualifiedName~DoctorTests"

# Nhóm UI
dotnet test --filter "FullyQualifiedName~UITests"

# Nhóm NFR
dotnet test --filter "FullyQualifiedName~NFRTests"
```

### Chạy một testcase cụ thể
```powershell
dotnet test --filter "FullyQualifiedName~TC_AUTH_008"
```

### Xuất báo cáo HTML (với NUnit Console Runner)
```powershell
dotnet test --results-directory TestResults --logger trx
```

## Ảnh chụp màn hình

Tất cả screenshot được lưu tại:
```
bin\Debug\net8.0\Screenshots\
```
Mỗi testcase tạo ít nhất 1 ảnh PNG tên theo mã testcase.

## Lưu ý khi chạy

1. **Khởi động emulator trước** (`emulator-5554` hoặc tên trong appsettings.json)
2. **Cài app Care4U lên emulator** trước khi test
3. **Khởi động Backend API** (dotnet run ở port 5130)
4. **Appium server** sẽ tự khởi động nếu chưa chạy, hoặc bạn có thể khởi động thủ công:
   ```powershell
   appium --log-timestamp
   ```
5. **noReset=true**: App không bị reset dữ liệu giữa các test trong cùng nhóm

## Credentials mặc định

| Vai trò | Tài khoản | Mật khẩu |
|---|---|---|
| Bệnh nhân | patient.an@gmail.com | 123456 |
| Bệnh nhân (SĐT) | 0326216310 | 123456 |
| Bác sĩ 1 | 0900000001 (LIC-001234) | 123456 |
| Admin | admin@care4u.vn | 123456 |

## Mapping 100 Testcase

| Nhóm | File | Số lượng | Range |
|---|---|---|---|
| AUTH | AuthTests.cs | 40 | TC_AUTH_001 – TC_AUTH_040 |
| DOC | DoctorTests.cs | 35 | TC_DOC_001 – TC_DOC_035 |
| UI | UITests.cs | 15 | TC_UI_001 – TC_UI_015 |
| NFR | NFRTests.cs | 10 | TC_NFR_001 – TC_NFR_010 |
| **Tổng** | | **100** | |
