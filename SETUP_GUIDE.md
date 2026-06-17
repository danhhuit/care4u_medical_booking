# 🚀 Setup & Development Guide - Care4U

## 📋 Mục Lục

1. [Prerequisites](#prerequisites)
2. [Environment Setup](#environment-setup)
3. [Project Setup](#project-setup)
4. [Running the App](#running-the-app)
5. [Configuration](#configuration)
6. [Troubleshooting](#troubleshooting)

---

## 📦 Prerequisites

### Required Software

- **Flutter**: 3.38.8+
  - Download: https://flutter.dev/docs/get-started/install
- **Dart**: 3.10.7+ (bundled with Flutter)

- **Android Studio**: 2024.1+
  - Download: https://developer.android.com/studio
  - Includes Android SDK

- **Git**: Latest version
  - Download: https://git-scm.com

- **Node.js** (Optional): 18+ (for Firebase CLI)

### Hardware Requirements

- **RAM**: 8GB minimum (16GB recommended)
- **Disk Space**: 20GB free for SDKs
- **Processor**: Intel i5/equivalent or better
- **Internet**: Good connection for downloading dependencies

### Supported Platforms

- ✅ Windows 10/11
- ✅ macOS 11+
- ✅ Linux (Ubuntu 20.04+)

---

## 🔧 Environment Setup

### 1. Install Flutter

#### Windows

```bash
# Download Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable

# Add Flutter to PATH
# Go to: System Properties > Environment Variables > PATH
# Add: C:\flutter\bin

# Verify installation
flutter --version
flutter doctor
```

#### macOS

```bash
# Using Homebrew
brew install flutter

# Or manual installation
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify
flutter --version
flutter doctor
```

#### Linux

```bash
# Install dependencies
sudo apt-get install -y git curl
sudo apt-get install -y bash completion curl file mkdir

# Clone Flutter
git clone https://github.com/flutter/flutter.git -b stable

# Add to PATH
export PATH="$PATH:$HOME/flutter/bin"

# Verify
flutter --version
flutter doctor
```

### 2. Install Android Studio & SDK

```bash
# Windows: Download from Android Studio website
# macOS: brew install android-studio
# Linux: Download from website

# After installation:
# 1. Open Android Studio
# 2. Go to SDK Manager
# 3. Install SDK Platform 21+ (for Care4U)
# 4. Install Android Emulator
# 5. Install Android SDK Build-Tools
```

### 3. Setup Android Emulator

```bash
# List available emulators
emulator -list-avds

# Create new emulator
avdmanager create avd -n care4u_emulator -k "system-images;android-33;google_apis;x86_64"

# Start emulator
emulator -avd care4u_emulator

# Or from Android Studio: AVD Manager > Create Virtual Device
```

### 4. Install Dependencies

```bash
# Get Flutter packages
flutter pub get

# Upgrade packages
flutter pub upgrade

# Get specific package
flutter pub add package_name

# Remove package
flutter pub remove package_name
```

---

## 📁 Project Setup

### 1. Clone Repository

```bash
# Clone project
git clone https://github.com/danhhuit/care4u_medical_booking.git

# Navigate to project
cd care4u_medical_booking

# Switch to develop branch
git checkout develop
```

### 2. Install Flutter Packages

```bash
# Get all dependencies
flutter pub get

# Get with upgrade
flutter pub upgrade --major-versions
```

### 3. Setup Firebase

#### Android Setup

1. Go to Firebase Console: https://console.firebase.google.com
2. Create new project or select existing
3. Add Android app
4. Download `google-services.json`
5. Place in `android/app/google-services.json`

#### iOS Setup (if needed)

1. Download `GoogleService-Info.plist`
2. Place in `ios/Runner/GoogleService-Info.plist`

### 4. Configure Backend API

Create/update `lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // API
  static const String baseUrl = 'http://10.0.2.2:5130/api'; // Emulator
  // static const String baseUrl = 'http://localhost:5130/api'; // Local
  // static const String baseUrl = 'https://api.care4u.com/api'; // Production

  // Firebase
  static const String firebaseProjectId = 'care4u-xxxxx';

  // App
  static const String appVersion = '1.0.0';
  static const String appName = 'Care4U Medical Booking';
}
```

---

## ▶️ Running the App

### 1. Basic Run

```bash
# Run on default device/emulator
flutter run

# Run with release mode (faster)
flutter run --release

# Run with profile mode (performance profiling)
flutter run --profile
```

### 2. Run on Specific Device

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run on Android emulator
flutter run -d emulator-5554

# Run on iOS simulator
flutter run -d all

# Run on Chrome web
flutter run -d chrome
```

### 3. Run with Hot Reload

```bash
# Press 'r' in terminal for hot reload
# Press 'R' for full restart
# Press 'q' to quit
```

---

## ⚙️ Configuration

### 1. Language Configuration

Default language is Vietnamese. To change:

```dart
// In lib/app/theme/settings_manager.dart
class SettingsManager {
  // Set initial language
  static const String defaultLanguage = 'vi'; // or 'en'

  // Users can change in settings
}
```

### 2. Theme Configuration

```dart
// Light mode (default)
// Dark mode can be enabled in settings

// Customize colors in lib/app/theme/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF2BB5A0); // Turquoise
  static const Color secondary = Color(0xFF5C6BC0); // Indigo
  // ... more colors
}
```

### 3. API Configuration

**For Local Development**:

```dart
static const String baseUrl = 'http://localhost:5130/api';
```

**For Emulator**:

```dart
static const String baseUrl = 'http://10.0.2.2:5130/api';
```

**For Production**:

```dart
static const String baseUrl = 'https://api.care4u.com/api';
```

### 4. Notification Configuration

Firebase Cloud Messaging (FCM) is pre-configured. Make sure:

1. Firebase project is setup
2. `google-services.json` is in `android/app/`
3. Backend is sending FCM messages

---

## 🏗️ Building

### Build APK (Android)

```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build App Bundle (Play Store)

```bash
# Build release bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

### Build iOS

```bash
# Build for iOS (requires macOS)
flutter build ios --release

# Output: build/ios/iphoneos/Runner.app
```

### Build Web

```bash
# Build for web
flutter build web --release

# Output: build/web/
```

---

## 🧪 Testing

### Run Unit Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/auth/auth_test.dart

# Run with coverage
flutter test --coverage
```

### Run Widget Tests

```bash
# Widget testing
flutter test test/widget_test.dart
```

### Run Integration Tests

```bash
# Integration testing
flutter drive --target=test_driver/app.dart
```

---

## 📝 Code Generation

Some packages require code generation:

```bash
# Generate code for build_runner packages
flutter pub run build_runner build

# Watch for changes and auto-generate
flutter pub run build_runner watch

# Clean generated files
flutter pub run build_runner clean
```

---

## 🐛 Troubleshooting

### Issue: Flutter not found

**Solution**:

```bash
# Check installation
flutter --version

# Check doctor
flutter doctor

# Add to PATH if needed
# Windows: System Properties > Environment Variables > PATH
# macOS/Linux: export PATH="$PATH:$HOME/flutter/bin"
```

### Issue: Gradle build failed

**Solution**:

```bash
# Clean build
flutter clean
flutter pub get
flutter run

# Or manually clean gradle
cd android
./gradlew clean
cd ..
flutter run
```

### Issue: Android emulator not starting

**Solution**:

```bash
# List available AVDs
emulator -list-avds

# Kill all emulator processes
adb kill-server

# Start emulator with more memory
emulator -avd care4u_emulator -memory 2048

# Or restart from Android Studio
```

### Issue: Firebase authentication errors

**Solution**:

1. Verify `google-services.json` is in `android/app/`
2. Check Firebase console configuration
3. Ensure app package name matches Firebase
4. Run `flutter clean` and rebuild

### Issue: API connection failed

**Solution**:

```bash
# For emulator, use http://10.0.2.2:5130 instead of localhost

# Test connection
# Ping backend: curl http://10.0.2.2:5130/api/health

# Check firewall
# Windows: Check Windows Defender Firewall
# macOS: Check System Preferences > Security & Privacy
```

### Issue: Hot reload not working

**Solution**:

```bash
# Do full restart
flutter run --no-fast-start

# Or restart the app:
# Press 'R' in terminal

# Last resort: rebuild
flutter clean
flutter pub get
flutter run
```

### Issue: Build errors after dependency update

**Solution**:

```bash
# Clean everything
flutter clean
flutter pub get

# Get new dependencies
flutter pub upgrade

# Rebuild
flutter run
```

---

## 📱 Device Debugging

### Connect Physical Device

**Android**:

1. Enable Developer Mode (tap Build Number 7 times)
2. Enable USB Debugging
3. Connect via USB
4. Run `adb devices` to verify
5. Run `flutter run`

**iOS**:

1. Connect iPhone via USB
2. Trust the computer
3. Run `flutter run`

### Debugging Commands

```bash
# List connected devices
adb devices

# View device logs
adb logcat

# View Flutter logs
flutter logs

# Debug session with DevTools
flutter run --devtools

# Launch DevTools explicitly
flutter pub global activate devtools
devtools
```

---

## 🔍 Performance Profiling

```bash
# Build with profiling
flutter run --profile

# Launch DevTools for performance analysis
flutter pub global activate devtools
devtools

# Connect to running app in DevTools
```

---

## 📊 Project Structure Verification

After setup, verify:

```bash
# Check project structure
flutter doctor

# Check dependencies
flutter pub get

# Analyze code
flutter analyze

# Format code
dart format lib/

# Check for unused imports
dart run -r bin/main.dart
```

---

## 🔐 Security Setup

### 1. Secure Storage

Key sensitive data uses `flutter_secure_storage`:

- Auth tokens
- Passwords
- API keys

### 2. SSL Pinning (Optional)

For production, implement certificate pinning:

```dart
// In lib/core/api/dio_interceptor.dart
final httpClient = HttpClient();
httpClient.badCertificateCallback =
  (X509Certificate cert, String host, int port) => false;
```

### 3. Obfuscation

```bash
# Build with obfuscation
flutter build apk --obfuscate --split-debug-info=./debug_info/
```

---

## 📦 Dependency Management

### Adding New Package

```bash
# Add package
flutter pub add package_name

# Add specific version
flutter pub add package_name:^1.0.0

# Add dev dependency
flutter pub add --dev package_name

# Update specific package
flutter pub upgrade package_name
```

### Remove Package

```bash
flutter pub remove package_name
```

---

## 📝 Git Workflow

### Basic Workflow

```bash
# Create feature branch
git checkout -b feature/awesome-feature

# Make changes
git add .
git commit -m "feat: add awesome feature"

# Push to remote
git push origin feature/awesome-feature

# Create Pull Request on GitHub
# After review and approval, merge to develop
```

### Branching Strategy

- `main`: Production-ready code
- `develop`: Development branch
- `feature/*`: Feature branches
- `bugfix/*`: Bug fix branches
- `release/*`: Release branches

---

## 🚀 CI/CD Setup (GitHub Actions)

Add `.github/workflows/flutter.yml`:

```yaml
name: Flutter CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

---

## 📞 Getting Help

- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.google.com/docs
- **GitHub Issues**: https://github.com/danhhuit/care4u_medical_booking/issues
- **Stack Overflow**: Tag `flutter`

---

**Setup Guide Version**: 1.0.0  
**Last Updated**: 2026-06-17  
**Status**: Complete
