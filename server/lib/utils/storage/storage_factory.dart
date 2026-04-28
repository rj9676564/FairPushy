import '../config.dart';
import 'local_storage_service.dart';
import 'oss_storage_service.dart';
import 'storage_service.dart';

class StorageFactory {
  static StorageService? _instance;

  static StorageService get i {
    if (_instance == null) {
      if (Config.storageType == 'oss') {
        _instance = OssStorageService(
          Config.ossEndpoint,
          Config.ossBucket,
          Config.ossAccessKey,
          Config.ossSecretKey,
        );
      } else {
        _instance = LocalStorageService(Config.storagePath);
      }
    }
    return _instance!;
  }
}
