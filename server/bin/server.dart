import 'dart:async';
import 'dart:io';

import 'package:HotUpdateService/server/fair_server_pages.dart';
import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/utils/fair_logger.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';
import 'package:HotUpdateService/utils/config.dart';

void main() async {
  LoggerInit();

  // 将环境变量写入 settings.yaml，供 simple_mysql_orm 初始化连接池。
  File('settings.yaml').writeAsStringSync(buildSettingsYaml());

  /// Initialise the db pool
  DbPool.fromSettings(pathToSettings: 'settings.yaml');

  runApp(
    GetServer(
      getPages: AppPages.routes,
      port: Config.serverPort,
    ),
  );
  print("FairServer ready...");
}
