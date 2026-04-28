import 'package:HotUpdateService/utils/config.dart';

class FairRequesterConstants {
  static String get baseUrl => 'http://127.0.0.1:${Config.serverPort}';
  static String get packingPlatformHost => 'http://127.0.0.1:${Config.serverPort}';
  static String get cdnFileHost => Config.cdnFileHost;
  static String get cdnTokenHost => Config.cdnTokenHost;

  //上传文件私有写接口
  static String cdnUploadFile() {
    return '/kLRHgFeDkLkL/dynamic/';
  }

  //获取token
  static String getCdnToken() {
    return '/get_token';
  }

  //打包平台在线构建接口
  static String onlineBuildInPackingPlatform() {
    return "/web/onlineBuild";
  }

  //打包平台检查构建状态
  static String checkBuildStatusInPackingPlatform() {
    return "/web/checkBuildStatus";
  }

}
