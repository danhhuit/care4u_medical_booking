import 'package:care4u_medical_booking/app/constants/api_constants.dart';

enum AppFlavor { dev, staging, prod }

class Env {
  Env._();

  static AppFlavor flavor = AppFlavor.dev;

  static String get baseUrl {
    switch (flavor) {
      case AppFlavor.dev:
        return ApiConstants.baseUrlDev;
      case AppFlavor.staging:
        return 'https://staging-api.care4u.vn/api';
      case AppFlavor.prod:
        return ApiConstants.baseUrlProd;
    }
  }

  static bool get enableLog {
    switch (flavor) {
      case AppFlavor.dev:
      case AppFlavor.staging:
        return true;
      case AppFlavor.prod:
        return false;
    }
  }

  static String get flavorName => flavor.name;
}
