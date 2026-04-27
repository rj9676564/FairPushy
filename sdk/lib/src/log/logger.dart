import 'package:flutter/foundation.dart';

class Logger {
  static void log(Object msg) {
    debugPrint('【FairPushy】：${msg.toString()}');
  }

  static void logi(String msg) {
    debugPrint("【FairPushy】：$msg");
  }
}
