import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/location_service.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/image_picker_service.dart';
import '../../core/services/maps_service.dart';
import '../../core/database/app_database.dart';

class DependencyInjection {
  DependencyInjection._();

  static late DioClient dioClient;
  static late TokenStorage tokenStorage;
  static late NotificationService notificationService;
  static late LocationService locationService;
  static late PermissionService permissionService;
  static late ImagePickerService imagePickerService;
  static late MapsService mapsService;
  static late AppDatabase appDatabase;

  static Future<void> init() async {
    dioClient = const DioClient();
    tokenStorage = TokenStorage();
    notificationService = NotificationService();
    locationService = LocationService();
    permissionService = PermissionService();
    imagePickerService = ImagePickerService();
    mapsService = MapsService();
    appDatabase = AppDatabase.instance;

    await dioClient.init();
    await notificationService.init();
    await appDatabase.database;
  }
}
