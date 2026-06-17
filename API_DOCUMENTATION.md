# 🔌 API Documentation - Care4U Backend

## 📋 Giới Thiệu

Tài liệu này mô tả toàn bộ REST API endpoints của Care4U Medical Booking backend (.NET/ASP.NET Core).

**Base URL**: `http://localhost:5130/api` (Local)  
**Base URL**: `http://10.0.2.2:5130/api` (Android Emulator)  
**Base URL**: `https://api.care4u.com/api` (Production)

**API Version**: v1.0  
**Authentication**: JWT Token (Bearer Token)

---

## 🔐 Authentication

### Đăng Nhập (Login)

**Endpoint**: `POST /Auth/Login`

**Request Body**:

```json
{
  "phoneNumber": "0123456789",
  "password": "password123"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Đăng nhập thành công",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": "user-123",
      "phoneNumber": "0123456789",
      "email": "user@example.com",
      "firstName": "Nguyễn",
      "lastName": "Văn A",
      "role": "Patient",
      "createdAt": "2026-01-01T10:00:00Z"
    }
  }
}
```

---

### Đăng Ký (Register)

**Endpoint**: `POST /Auth/Register`

**Request Body**:

```json
{
  "phoneNumber": "0123456789",
  "email": "user@example.com",
  "password": "password123",
  "firstName": "Nguyễn",
  "lastName": "Văn A",
  "dateOfBirth": "1990-01-01"
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "message": "Đăng ký thành công",
  "data": {
    "id": "user-123",
    "phoneNumber": "0123456789",
    "email": "user@example.com"
  }
}
```

---

### Refresh Token

**Endpoint**: `POST /Auth/RefreshToken`

**Headers**:

```
Authorization: Bearer <refresh_token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "refreshToken": "..."
  }
}
```

---

## 👨‍⚕️ Doctors API

### Lấy Danh Sách Bác Sĩ

**Endpoint**: `GET /Doctors`

**Query Parameters**:

```
GET /Doctors?page=1&pageSize=10&specialtyId=1&rating=4&sortBy=name
```

| Parameter     | Type    | Mô Tả                              |
| ------------- | ------- | ---------------------------------- |
| `page`        | int     | Trang (mặc định: 1)                |
| `pageSize`    | int     | Số lượng/trang (mặc định: 10)      |
| `specialtyId` | string  | Lọc theo chuyên khoa               |
| `rating`      | decimal | Lọc theo đánh giá tối thiểu        |
| `search`      | string  | Tìm kiếm theo tên                  |
| `sortBy`      | string  | Sắp xếp (name, rating, experience) |

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "doctor-1",
        "firstName": "Bác Sĩ",
        "lastName": "Hùng",
        "avatar": "https://...",
        "specialtyName": "Tim mạch",
        "bio": "Bác sĩ chuyên khoa tim mạch có 15 năm kinh nghiệm",
        "experience": 15,
        "rating": 4.8,
        "reviewCount": 245,
        "consultationFee": 500000,
        "availableSlots": [
          {
            "date": "2026-06-20",
            "slots": ["09:00", "09:30", "10:00"]
          }
        ]
      }
    ],
    "totalCount": 156,
    "page": 1,
    "pageSize": 10
  }
}
```

---

### Lấy Chi Tiết Bác Sĩ

**Endpoint**: `GET /Doctors/{doctorId}`

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": "doctor-1",
    "firstName": "Bác Sĩ",
    "lastName": "Hùng",
    "email": "doctor@example.com",
    "phoneNumber": "0987654321",
    "avatar": "https://...",
    "specialtyId": "spec-1",
    "specialtyName": "Tim mạch",
    "bio": "...",
    "education": "Đại học Y Hà Nội (2008)",
    "experience": 15,
    "hospital": "Bệnh viện Đại học Y Hà Nội",
    "rating": 4.8,
    "reviewCount": 245,
    "consultationFee": 500000,
    "certificates": [
      {
        "name": "Chuyên khoa Tim mạch",
        "issuedDate": "2010-06-15"
      }
    ],
    "workingHours": {
      "monday": { "start": "09:00", "end": "17:00" },
      "tuesday": { "start": "09:00", "end": "17:00" },
      "wednesday": null,
      "thursday": { "start": "09:00", "end": "17:00" },
      "friday": { "start": "09:00", "end": "17:00" },
      "saturday": { "start": "09:00", "end": "12:00" }
    }
  }
}
```

---

## 📅 Appointments API

### Lấy Danh Sách Lịch Hẹn

**Endpoint**: `GET /Appointments`

**Headers**:

```
Authorization: Bearer <token>
```

**Query Parameters**:

```
GET /Appointments?page=1&status=upcoming
```

| Parameter | Type   | Mô Tả                          |
| --------- | ------ | ------------------------------ |
| `status`  | string | upcoming, completed, cancelled |
| `page`    | int    | Trang (mặc định: 1)            |

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "apt-123",
        "doctorId": "doctor-1",
        "doctorName": "Bác Sĩ Hùng",
        "doctorAvatar": "https://...",
        "specialty": "Tim mạch",
        "appointmentDate": "2026-06-20",
        "appointmentTime": "09:00",
        "reason": "Khám tổng quát",
        "status": "upcoming",
        "location": "Bệnh viện Đại học Y Hà Nội",
        "consultationFee": 500000,
        "paymentStatus": "paid",
        "notes": "..."
      }
    ],
    "totalCount": 5,
    "page": 1
  }
}
```

---

### Tạo Lịch Hẹn

**Endpoint**: `POST /Appointments`

**Headers**:

```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body**:

```json
{
  "doctorId": "doctor-1",
  "appointmentDate": "2026-06-20",
  "appointmentTime": "09:00",
  "reason": "Khám tổng quát",
  "notes": "Có dị ứng với penicillin",
  "location": "Bệnh viện Đại học Y Hà Nội"
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "message": "Lịch hẹn được tạo thành công",
  "data": {
    "id": "apt-123",
    "confirmationCode": "APT-20260620-001",
    "status": "confirmed",
    "appointmentDate": "2026-06-20",
    "appointmentTime": "09:00"
  }
}
```

---

### Cập Nhật Lịch Hẹn

**Endpoint**: `PUT /Appointments/{appointmentId}`

**Request Body**:

```json
{
  "appointmentDate": "2026-06-21",
  "appointmentTime": "10:00",
  "reason": "Khám tổng quát"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Lịch hẹn được cập nhật thành công"
}
```

---

### Hủy Lịch Hẹn

**Endpoint**: `DELETE /Appointments/{appointmentId}`

**Headers**:

```
Authorization: Bearer <token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Lịch hẹn được hủy thành công"
}
```

---

## 💊 Prescriptions API

### Lấy Danh Sách Đơn Thuốc

**Endpoint**: `GET /Prescriptions`

**Headers**:

```
Authorization: Bearer <token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "presc-123",
        "prescriptionCode": "RX-20260615-001",
        "doctorName": "Bác Sĩ Hùng",
        "issuedDate": "2026-06-15",
        "expiryDate": "2026-09-15",
        "medicines": [
          {
            "name": "Amoxicillin 500mg",
            "dosage": "500mg",
            "frequency": "3 lần/ngày",
            "duration": "7 ngày",
            "notes": "Uống cùng nước"
          }
        ],
        "diagnosis": "Viêm phổi",
        "status": "active"
      }
    ],
    "totalCount": 3
  }
}
```

---

### Lấy Chi Tiết Đơn Thuốc

**Endpoint**: `GET /Prescriptions/{prescriptionId}`

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": "presc-123",
    "prescriptionCode": "RX-20260615-001",
    "doctorId": "doctor-1",
    "doctorName": "Bác Sĩ Hùng",
    "patientId": "patient-1",
    "issuedDate": "2026-06-15",
    "expiryDate": "2026-09-15",
    "diagnosis": "Viêm phổi",
    "medicines": [
      {
        "medicineId": "med-1",
        "name": "Amoxicillin 500mg",
        "quantity": 21,
        "dosage": "500mg",
        "frequency": "3 lần/ngày",
        "duration": "7 ngày",
        "notes": "Uống cùng nước",
        "sideEffects": "Có thể gây dị ứng"
      }
    ],
    "notes": "Tái khám sau 1 tuần",
    "status": "active"
  }
}
```

---

## 📋 Medical Records API

### Lấy Danh Sách Hồ Sơ Y Tế

**Endpoint**: `GET /MedicalRecords`

**Headers**:

```
Authorization: Bearer <token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "record-123",
        "visitDate": "2026-06-15",
        "doctorName": "Bác Sĩ Hùng",
        "specialty": "Tim mạch",
        "reason": "Khám tổng quát",
        "diagnosis": "Khỏe mạnh",
        "symptoms": "Không có triệu chứng",
        "treatment": "Khám bình thường",
        "vitalSigns": {
          "bloodPressure": "120/80",
          "heartRate": 70,
          "temperature": 36.5,
          "respiratoryRate": 16
        }
      }
    ],
    "totalCount": 15
  }
}
```

---

### Lấy Chi Tiết Hồ Sơ

**Endpoint**: `GET /MedicalRecords/{recordId}`

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": "record-123",
    "visitDate": "2026-06-15",
    "doctorId": "doctor-1",
    "doctorName": "Bác Sĩ Hùng",
    "specialty": "Tim mạch",
    "reason": "Khám tổng quát",
    "symptoms": "Không có triệu chứng",
    "diagnosis": "Khỏe mạnh",
    "treatment": "Khám bình thường",
    "notes": "Tái khám sau 1 năm",
    "icdCode": "Z00.00",
    "vitalSigns": {
      "bloodPressure": "120/80",
      "heartRate": 70,
      "temperature": 36.5,
      "respiratoryRate": 16,
      "weight": 70,
      "height": 175
    },
    "attachments": [
      {
        "id": "att-1",
        "filename": "xray_chest.jpg",
        "type": "image/jpeg",
        "url": "https://..."
      }
    ]
  }
}
```

---

## 💬 Chat API

### Lấy Danh Sách Phòng Chat

**Endpoint**: `GET /ChatRooms`

**Headers**:

```
Authorization: Bearer <token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "room-123",
        "participantId": "doctor-1",
        "participantName": "Bác Sĩ Hùng",
        "participantAvatar": "https://...",
        "lastMessage": "Bạn có khỏe hơn không?",
        "lastMessageTime": "2026-06-18T10:30:00Z",
        "unreadCount": 2,
        "status": "online"
      }
    ],
    "totalCount": 5
  }
}
```

---

### Lấy Lịch Sử Chat

**Endpoint**: `GET /ChatRooms/{roomId}/Messages`

**Query Parameters**:

```
GET /ChatRooms/room-123/Messages?page=1&pageSize=20
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "msg-1",
        "senderId": "patient-1",
        "senderName": "Bệnh nhân",
        "content": "Bác sĩ ơi, tôi bị ho liên tục",
        "timestamp": "2026-06-18T10:25:00Z",
        "isRead": true
      },
      {
        "id": "msg-2",
        "senderId": "doctor-1",
        "senderName": "Bác Sĩ Hùng",
        "content": "Bạn có chảy nước mũi không?",
        "timestamp": "2026-06-18T10:30:00Z",
        "isRead": true
      }
    ],
    "totalCount": 45,
    "page": 1
  }
}
```

---

### Gửi Tin Nhắn

**Endpoint**: `POST /ChatRooms/{roomId}/Messages`

**Headers**:

```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body**:

```json
{
  "content": "Bác sĩ ơi, tôi bị ho liên tục",
  "attachments": ["file-id-1", "file-id-2"]
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "data": {
    "id": "msg-123",
    "content": "Bác sĩ ơi, tôi bị ho liên tục",
    "timestamp": "2026-06-18T10:25:00Z"
  }
}
```

---

## ⭐ Reviews API

### Lấy Danh Sách Đánh Giá Bác Sĩ

**Endpoint**: `GET /Doctors/{doctorId}/Reviews`

**Query Parameters**:

```
GET /Doctors/doctor-1/Reviews?page=1&sortBy=newest
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "review-1",
        "patientName": "Nguyễn Văn A",
        "rating": 5,
        "comment": "Bác sĩ rất tâm huyết và chuyên nghiệp",
        "visitDate": "2026-06-10",
        "createdAt": "2026-06-15",
        "helpful": 12
      }
    ],
    "averageRating": 4.8,
    "totalReviews": 245,
    "page": 1
  }
}
```

---

### Gửi Đánh Giá

**Endpoint**: `POST /Appointments/{appointmentId}/Reviews`

**Headers**:

```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body**:

```json
{
  "rating": 5,
  "comment": "Bác sĩ rất tâm huyết và chuyên nghiệp"
}
```

**Response** (201 Created):

```json
{
  "success": true,
  "message": "Đánh giá được gửi thành công",
  "data": {
    "id": "review-123",
    "rating": 5,
    "comment": "Bác sĩ rất tâm huyết và chuyên nghiệp"
  }
}
```

---

## 🛒 Products API

### Lấy Danh Sách Sản Phẩm

**Endpoint**: `GET /Products`

**Query Parameters**:

```
GET /Products?page=1&category=medicines&search=amoxicillin&sort=price
```

| Parameter  | Type   | Mô Tả                     |
| ---------- | ------ | ------------------------- |
| `page`     | int    | Trang                     |
| `pageSize` | int    | Số lượng/trang            |
| `category` | string | medicines, devices, care  |
| `search`   | string | Tìm kiếm                  |
| `sort`     | string | price, popularity, rating |

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "prod-1",
        "name": "Amoxicillin 500mg",
        "description": "Kháng sinh amoxicillin",
        "category": "medicines",
        "price": 50000,
        "discountPrice": 40000,
        "image": "https://...",
        "rating": 4.7,
        "reviews": 120,
        "inStock": true,
        "quantity": 100
      }
    ],
    "totalCount": 1250,
    "page": 1
  }
}
```

---

### Lấy Chi Tiết Sản Phẩm

**Endpoint**: `GET /Products/{productId}`

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": "prod-1",
    "name": "Amoxicillin 500mg",
    "description": "Kháng sinh amoxicillin",
    "category": "medicines",
    "manufacturer": "Công ty A",
    "price": 50000,
    "discountPrice": 40000,
    "images": ["https://...", "https://..."],
    "rating": 4.7,
    "reviews": 120,
    "inStock": true,
    "quantity": 100,
    "specifications": {
      "strength": "500mg",
      "form": "Capsule",
      "quantity": 10,
      "expiryDate": "2027-06-01"
    }
  }
}
```

---

## 💳 Payments API

### Lấy Thông Tin Ví

**Endpoint**: `GET /Wallet`

**Headers**:

```
Authorization: Bearer <token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "balance": 5000000,
    "currency": "VND",
    "lastTopUp": "2026-06-15T10:00:00Z",
    "totalTransactions": 25
  }
}
```

---

### Nạp Tiền Vào Ví

**Endpoint**: `POST /Wallet/TopUp`

**Request Body**:

```json
{
  "amount": 1000000,
  "paymentMethod": "vietqr"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "transactionId": "txn-123",
    "amount": 1000000,
    "status": "pending",
    "qrCode": "https://..."
  }
}
```

---

### Lấy Lịch Sử Giao Dịch

**Endpoint**: `GET /Transactions`

**Query Parameters**:

```
GET /Transactions?page=1&type=all&startDate=2026-06-01
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "txn-123",
        "type": "topup",
        "amount": 1000000,
        "status": "completed",
        "description": "Nạp tiền vào ví",
        "timestamp": "2026-06-15T10:00:00Z"
      },
      {
        "id": "txn-124",
        "type": "payment",
        "amount": 500000,
        "status": "completed",
        "description": "Thanh toán lịch khám bác sĩ Hùng",
        "timestamp": "2026-06-15T09:30:00Z"
      }
    ],
    "totalCount": 25,
    "page": 1
  }
}
```

---

## 👤 User Profile API

### Lấy Thông Tin Người Dùng

**Endpoint**: `GET /Users/Profile`

**Headers**:

```
Authorization: Bearer <token>
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "id": "user-123",
    "phoneNumber": "0123456789",
    "email": "user@example.com",
    "firstName": "Nguyễn",
    "lastName": "Văn A",
    "avatar": "https://...",
    "dateOfBirth": "1990-01-01",
    "gender": "male",
    "address": "Hà Nội, Việt Nam",
    "bloodType": "O+",
    "height": 175,
    "weight": 70,
    "allergies": ["Penicillin"],
    "chronicDiseases": ["Diabetes"],
    "createdAt": "2026-01-01",
    "role": "Patient"
  }
}
```

---

### Cập Nhật Thông Tin Người Dùng

**Endpoint**: `PUT /Users/Profile`

**Headers**:

```
Authorization: Bearer <token>
Content-Type: application/json
```

**Request Body**:

```json
{
  "firstName": "Nguyễn",
  "lastName": "Văn A",
  "dateOfBirth": "1990-01-01",
  "gender": "male",
  "address": "Hà Nội, Việt Nam",
  "bloodType": "O+",
  "height": 175,
  "weight": 70,
  "allergies": ["Penicillin"],
  "chronicDiseases": ["Diabetes"]
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Hồ sơ được cập nhật thành công"
}
```

---

### Thay Đổi Mật Khẩu

**Endpoint**: `POST /Users/ChangePassword`

**Request Body**:

```json
{
  "currentPassword": "oldpassword123",
  "newPassword": "newpassword123"
}
```

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Mật khẩu được thay đổi thành công"
}
```

---

## 🔔 Notifications API

### Lấy Danh Sách Thông Báo

**Endpoint**: `GET /Notifications`

**Headers**:

```
Authorization: Bearer <token>
```

**Query Parameters**:

```
GET /Notifications?page=1&unreadOnly=false
```

**Response** (200 OK):

```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "notif-1",
        "type": "appointment_reminder",
        "title": "Nhắc nhở lịch khám",
        "message": "Bạn có lịch khám với bác sĩ Hùng vào ngày mai lúc 9:00",
        "timestamp": "2026-06-18T10:00:00Z",
        "isRead": false,
        "data": {
          "appointmentId": "apt-123"
        }
      }
    ],
    "totalCount": 15,
    "unreadCount": 3,
    "page": 1
  }
}
```

---

### Đánh Dấu Thông Báo Đã Đọc

**Endpoint**: `PUT /Notifications/{notificationId}/Read`

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Thông báo được đánh dấu là đã đọc"
}
```

---

### Đánh Dấu Tất Cả Thông Báo Đã Đọc

**Endpoint**: `PUT /Notifications/ReadAll`

**Response** (200 OK):

```json
{
  "success": true,
  "message": "Tất cả thông báo được đánh dấu là đã đọc"
}
```

---

## ⚠️ Error Responses

### 400 Bad Request

```json
{
  "success": false,
  "message": "Request không hợp lệ",
  "errors": {
    "phoneNumber": ["Số điện thoại không hợp lệ"]
  }
}
```

### 401 Unauthorized

```json
{
  "success": false,
  "message": "Token hết hạn hoặc không hợp lệ"
}
```

### 403 Forbidden

```json
{
  "success": false,
  "message": "Bạn không có quyền truy cập tài nguyên này"
}
```

### 404 Not Found

```json
{
  "success": false,
  "message": "Tài nguyên không tìm thấy"
}
```

### 500 Internal Server Error

```json
{
  "success": false,
  "message": "Lỗi server. Vui lòng thử lại sau"
}
```

---

## 📊 Status Codes

| Code | Meaning               | Description                    |
| ---- | --------------------- | ------------------------------ |
| 200  | OK                    | Request thành công             |
| 201  | Created               | Tài nguyên được tạo thành công |
| 400  | Bad Request           | Request không hợp lệ           |
| 401  | Unauthorized          | Cần xác thực                   |
| 403  | Forbidden             | Không có quyền                 |
| 404  | Not Found             | Tài nguyên không tìm thấy      |
| 500  | Internal Server Error | Lỗi server                     |

---

## 🔐 Authentication Flow

```
1. User gọi POST /Auth/Login
   ↓
2. Server trả về JWT Token
   ↓
3. Client lưu Token (SharedPreferences)
   ↓
4. Mỗi request gửi Token trong header:
   Authorization: Bearer <token>
   ↓
5. Server xác thực Token
   ↓
6. Nếu hợp lệ → xử lý request
   Nếu hết hạn → Client gọi RefreshToken
```

---

## 🧪 Testing API

### Postman Collection

Import từ Postman:

```json
{
  "info": {
    "name": "Care4U API",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "auth": {
    "type": "bearer",
    "bearer": [
      {
        "key": "token",
        "value": "{{jwt_token}}"
      }
    ]
  }
}
```

### cURL Examples

**Login**:

```bash
curl -X POST http://localhost:5130/api/Auth/Login \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"0123456789","password":"password123"}'
```

**Get Doctors**:

```bash
curl -X GET "http://localhost:5130/api/Doctors?page=1&pageSize=10" \
  -H "Authorization: Bearer <token>"
```

---

## 📝 Rate Limiting

- **Requests per minute**: 60
- **Requests per hour**: 1000
- **Headers**:
  - `X-RateLimit-Limit`: 60
  - `X-RateLimit-Remaining`: 59
  - `X-RateLimit-Reset`: 1624008000

---

**API Version**: 1.0.0  
**Last Updated**: 2026-06-17  
**Status**: Stable
