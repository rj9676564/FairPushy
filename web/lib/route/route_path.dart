/// 路由定义
class RoutePath {
  static const String login = 'login';
  static const String home = 'home';
  static const String monitor = 'monitor';
  static const String appRes = 'app_res';

  static String get loginPath => Uri(scheme: 'fair', host: login).toString();
  static String get homePath => Uri(scheme: 'fair', host: home).toString();
  static String appResPath(int appId) => Uri(scheme: 'fair', host: appRes, queryParameters: {'appId': appId.toString()}).toString();
}
