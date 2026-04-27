// ignore_for_file: constant_identifier_names

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  Future<PermissionResult> checkPermission(PermissionEnum permission) async {
    PermissionStatus permissionStatus = await Permission.storage.status;
    switch (permission) {
      case PermissionEnum.FILE_READ:
      case PermissionEnum.FILE_WRITE:
        permissionStatus = await Permission.storage.status;
        break;
      case PermissionEnum.INTERNET:
        permissionStatus = await Permission.storage.status;
        break;
    }

    if (permissionStatus.isGranted) {
      return PermissionResult.GRANTED;
    }
    return PermissionResult.DENIED;
  }
}

enum PermissionEnum { FILE_READ, FILE_WRITE, INTERNET }

enum PermissionResult { GRANTED, DENIED }
