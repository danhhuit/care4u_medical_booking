# 🏗️ Architecture & Features Guide - Care4U

## 📚 Mục Lục

1. [Kiến Trúc Ứng Dụng](#kiến-trúc-ứng-dụng)
2. [Cấu Trúc Thư Mục](#cấu-trúc-thư-mục)
3. [Features Chi Tiết](#features-chi-tiết)
4. [State Management](#state-management)
5. [Navigation](#navigation)
6. [Data Flow](#data-flow)

---

## 🏗️ Kiến Trúc Ứng Dụng

### Clean Architecture Pattern

Care4U sử dụng **Clean Architecture** chia ứng dụng thành 3 tầng:

```
┌─────────────────────────────────────┐
│   Presentation Layer (UI)           │
│  (Screens, Widgets, Controllers)    │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│   Domain Layer (Business Logic)     │
│  (Entities, UseCases, Repositories) │
└─────────────────┬───────────────────┘
                  │
                  ▼
┌─────────────────────────────────────┐
│   Data Layer (Data Management)      │
│  (Models, DataSources, API)         │
└─────────────────────────────────────┘
```

### Lợi Ích

✅ **Testability**: Dễ viết unit tests  
✅ **Maintainability**: Dễ bảo trì và mở rộng  
✅ **Scalability**: Dễ thêm features mới  
✅ **Separation of Concerns**: Tách biệt trách nhiệm  
✅ **Reusability**: Tái sử dụng code

---

## 📁 Cấu Trúc Thư Mục

### Toàn Cơ Bản

```
lib/
├── main.dart                          # Entry point, Firebase init
├── app/
│   ├── app.dart                       # Material App configuration
│   ├── router/
│   │   ├── app_router.dart            # Route definitions (30+ routes)
│   │   └── route_names.dart           # Route constants
│   └── theme/
│       ├── app_colors.dart            # Color palette
│       ├── app_text_styles.dart       # Text styles
│       ├── app_theme.dart             # Light/Dark themes
│       └── settings_manager.dart      # Theme & Language settings
│
├── core/
│   ├── api/
│   │   ├── care4u_api_service.dart    # Main API client
│   │   ├── dio_interceptor.dart       # Request/Response interceptor
│   │   └── api_endpoints.dart         # All endpoints
│   │
│   ├── services/
│   │   ├── firebase_service.dart      # Firebase initialization
│   │   ├── location_service.dart      # GPS location
│   │   ├── notification_service.dart  # Push notifications
│   │   └── storage_service.dart       # Secure storage
│   │
│   ├── constants/
│   │   ├── app_constants.dart         # App constants
│   │   ├── asset_paths.dart           # Image/asset paths
│   │   └── translations.dart          # Multi-language strings
│   │
│   └── utils/
│       ├── date_utils.dart            # Date formatting
│       ├── validators.dart            # Input validators
│       └── extensions.dart            # Extension methods
│
├── features/
│   │
│   ├── auth/                          # Authentication Feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── local_data_source.dart
│   │   │   │   └── remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       ├── register_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       ├── screens/
│   │       │   ├── splash_screen.dart
│   │       │   ├── login_phone_screen.dart
│   │       │   └── register_screen.dart
│   │       └── widgets/
│   │           ├── phone_input_field.dart
│   │           └── password_field.dart
│   │
│   ├── home/                          # Home Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       └── screens/
│   │           └── home_screen.dart
│   │
│   ├── appointments/                  # Appointments Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── screens/
│   │       │   ├── appointments_screen.dart
│   │       │   ├── appointment_detail_screen.dart
│   │       │   ├── book_appointment_screen.dart
│   │       │   ├── map_booking_screen.dart
│   │       │   └── reschedule_appointment_screen.dart
│   │       └── widgets/
│   │           ├── appointment_card.dart
│   │           ├── date_time_picker.dart
│   │           └── reason_input.dart
│   │
│   ├── doctors/                       # Doctors Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── controllers/
│   │       ├── screens/
│   │       │   ├── doctors_screen.dart
│   │       │   ├── doctor_detail_screen.dart
│   │       │   └── specialty_filter_screen.dart
│   │       └── widgets/
│   │           ├── doctor_card.dart
│   │           ├── doctor_header.dart
│   │           └── available_slots.dart
│   │
│   ├── prescriptions/                 # Prescriptions Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── prescription_list_screen.dart
│   │       │   └── prescription_detail_screen.dart
│   │       └── widgets/
│   │           └── medicine_item.dart
│   │
│   ├── medical_records/               # Medical Records Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── medical_record_list_screen.dart
│   │       │   └── medical_record_detail_screen.dart
│   │       └── widgets/
│   │           └── vital_signs_display.dart
│   │
│   ├── patient_profile/               # Patient Profile Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── patient_profile_screen.dart
│   │       │   ├── edit_profile_screen.dart
│   │       │   └── settings_screen.dart
│   │       └── widgets/
│   │           └── profile_avatar.dart
│   │
│   ├── notifications/                 # Notifications Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── screens/
│   │           └── notification_list_screen.dart
│   │
│   ├── chat/                          # Chat Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── chat_rooms_screen.dart
│   │       │   └── chat_detail_screen.dart
│   │       └── widgets/
│   │           ├── message_bubble.dart
│   │           └── message_input.dart
│   │
│   ├── reviews/                       # Reviews Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── review_list_screen.dart
│   │       │   └── review_form_screen.dart
│   │       └── widgets/
│   │           └── star_rating.dart
│   │
│   ├── store/                         # Store/E-commerce Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── product_list_screen.dart
│   │       │   ├── product_detail_screen.dart
│   │       │   ├── cart_screen.dart
│   │       │   └── order_history_screen.dart
│   │       └── widgets/
│   │           ├── product_card.dart
│   │           ├── cart_item.dart
│   │           └── checkout_form.dart
│   │
│   ├── payments/                      # Payments Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   ├── wallet_screen.dart
│   │       │   ├── top_up_screen.dart
│   │       │   ├── vietqr_payment_screen.dart
│   │       │   └── transaction_history_screen.dart
│   │       └── widgets/
│   │           └── wallet_card.dart
│   │
│   ├── specialties/                   # Specialties Feature
│   │   └── presentation/
│   │       └── screens/
│   │           └── specialties_screen.dart
│   │
│   ├── health_center/                 # Health Centers Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── screens/
│   │       │   └── health_center_screen.dart
│   │       └── widgets/
│   │           └── map_widget.dart
│   │
│   └── admin/                         # Admin Feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── screens/
│           │   ├── admin_dashboard_screen.dart
│           │   ├── admin_users_screen.dart
│           │   └── admin_user_detail_screen.dart
│           └── widgets/
│               └── user_table.dart
│
└── shared/                            # Shared Components
    ├── widgets/
    │   ├── custom_app_bar.dart        # Custom app bar
    │   ├── custom_button.dart         # Button widget
    │   ├── loading_dialog.dart        # Loading dialog
    │   ├── error_dialog.dart          # Error dialog
    │   └── bottom_nav_bar.dart        # Bottom navigation
    │
    ├── components/
    │   ├── main_screen.dart           # Main container with nav
    │   ├── tab_selector.dart          # Tab widget
    │   └── card_layout.dart           # Card layout
    │
    └── utils/
        ├── logger.dart                # Logging utility
        ├── dialog_helper.dart         # Dialog helpers
        └── toast_helper.dart          # Toast helpers
```

---

## ✨ Features Chi Tiết

### 1. Authentication Module

**Location**: `lib/features/auth/`

**Screens**:

- `SplashScreen`: Khởi động app, kiểm tra token
- `LoginPhoneScreen`: Đăng nhập bằng phone
- `RegisterScreen`: Tạo tài khoản mới

**Key Classes**:

- `AuthRepository`: Interface cho auth operations
- `AuthRepositoryImpl`: Implementation
- `LoginUseCase`: Use case cho login
- `AuthController`: Provider controller

**Key Features**:

- JWT authentication
- Token refresh
- Secure storage
- Auto-login

---

### 2. Home Module

**Location**: `lib/features/home/`

**Screens**:

- `HomeScreen`: Trang chủ chính
- Quick actions slider
- Drawer menu

**Components**:

- Personalized greeting
- Quick action buttons
- Services showcase
- Search bar

---

### 3. Doctors Module

**Location**: `lib/features/doctors/`

**Screens**:

- `DoctorsScreen`: Danh sách bác sĩ
- `DoctorDetailScreen`: Chi tiết bác sĩ
- Filters & Search

**Features**:

- Filter by specialty
- Search by name
- View availability
- See reviews
- Call/Chat integration

---

### 4. Appointments Module

**Location**: `lib/features/appointments/`

**Screens**:

- `AppointmentsScreen`: Danh sách lịch (tabs: upcoming, completed, cancelled)
- `BookAppointmentScreen`: Form đặt lịch
- `MapBookingScreen`: Chọn vị trí trên bản đồ
- `RescheduleAppointmentScreen`: Chỉnh sửa lịch

**Features**:

- Book appointment
- Reschedule
- Cancel appointment
- View appointment details
- Receive reminders

---

### 5. Medical Records Module

**Location**: `lib/features/medical_records/`

**Features**:

- View visit history
- See diagnoses
- View vital signs
- See treatment plans
- Download records

---

### 6. Chat Module

**Location**: `lib/features/chat/`

**Features**:

- Real-time messaging
- View chat history
- Message notifications
- Online/offline status
- File attachments

---

### 7. Store/E-commerce Module

**Location**: `lib/features/store/`

**Screens**:

- Product list with categories
- Product details
- Shopping cart
- Order checkout
- Order history

**Features**:

- Search & filter
- Add to cart
- Wishlist
- Order tracking
- Reviews

---

### 8. Payments Module

**Location**: `lib/features/payments/`

**Features**:

- Wallet management
- Top-up
- VietQR payments
- Transaction history
- Payment methods

---

## 🔄 State Management

### Provider Pattern

Care4U menggunakan **Provider** untuk state management.

**Contoh**:

```dart
// Provider definition
final authControllerProvider = StateNotifierProvider((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

// Usage in Widget
@override
Widget build(BuildContext context, WidgetRef ref) {
  final authState = ref.watch(authControllerProvider);

  return authState.when(
    data: (user) => HomeScreen(),
    loading: () => LoadingScreen(),
    error: (err, stack) => ErrorScreen(),
  );
}
```

### Key Providers

- `authControllerProvider`: Authentication state
- `doctorControllerProvider`: Doctor list state
- `appointmentControllerProvider`: Appointments state
- `userProfileProvider`: User profile state
- `settingsProvider`: App settings

---

## 🧭 Navigation

### Named Routes

```dart
// In app_router.dart
static const String home = '/home';
static const String doctors = '/doctors';
static const String doctorDetail = '/doctor-detail';
static const String bookAppointment = '/book-appointment';
static const String appointments = '/appointments';
// ... 30+ routes
```

### Navigation Examples

```dart
// Push named route
Navigator.pushNamed(context, AppRoutes.doctorDetail,
  arguments: doctorId);

// Pop back
Navigator.pop(context);

// Replace route
Navigator.pushReplacementNamed(context, AppRoutes.home);
```

---

## 💾 Data Flow

### Appointment Booking Flow

```
User Tap "Book Now"
        ↓
BookAppointmentScreen opens
        ↓
User select date & time
        ↓
User enters reason
        ↓
User tap "Confirm"
        ↓
BookAppointmentController.bookAppointment()
        ↓
AppointmentRepository.createAppointment()
        ↓
Care4UApiService.post('/Appointments')
        ↓
Backend creates appointment
        ↓
Response returns with appointmentId
        ↓
Controller updates state
        ↓
Show success dialog
        ↓
Navigate to AppointmentDetailScreen
        ↓
Fetch updated appointments list
```

---

## 🔐 Security Measures

1. **JWT Tokens**: Secure authentication
2. **Secure Storage**: Encrypted token storage
3. **HTTPS**: SSL/TLS encryption
4. **Input Validation**: Prevent injection attacks
5. **Firebase Security Rules**: Database access control
6. **Biometric Auth**: Optional fingerprint/face

---

## 📱 Responsive Design

The app uses:

- **MediaQuery** for screen size detection
- **Flexible** & **Expanded** widgets for responsive layouts
- **AspectRatio** for consistent proportions
- Breakpoints for different screen sizes

```dart
// Responsive layout example
MediaQuery.of(context).size.width > 600
  ? Row(children: [...])  // Tablet layout
  : Column(children: [...])  // Phone layout
```

---

## 🌐 Multi-language Support

The app supports:

- **Vietnamese** (VI)
- **English** (EN)

**Implementation**:

```dart
// In constants/translations.dart
class AppTranslations {
  static const Map<String, Map<String, String>> translations = {
    'vi': {
      'home': 'Trang Chủ',
      'doctors': 'Bác Sĩ',
    },
    'en': {
      'home': 'Home',
      'doctors': 'Doctors',
    }
  };
}
```

---

## 🎨 Theme System

**Light Theme**:

- Primary: Turquoise (#2BB5A0)
- Background: White
- Text: Dark grey

**Dark Theme**:

- Primary: Turquoise (#2BB5A0)
- Background: Dark grey (#121212)
- Text: White

---

## 🧪 Testing

**Unit Tests**:

- Repository tests
- UseCase tests
- Model tests

**Widget Tests**:

- Screen rendering
- User interactions
- State changes

**Integration Tests**:

- Full user flows
- API integration

---

## 📦 Dependencies Management

Key dependencies in `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2
  dio: ^5.7.0
  firebase_core: ^4.10.0
  firebase_auth: ^6.5.1
  cloud_firestore: ^6.4.1
  google_maps_flutter: ^2.16.0
  # ... more dependencies
```

---

**Document Version**: 1.0.0  
**Last Updated**: 2026-06-17  
**Status**: Complete
