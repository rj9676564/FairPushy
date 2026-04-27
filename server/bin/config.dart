import 'dart:io';

/// 默认数据库配置。
/// 当运行环境提供同名环境变量时，优先使用环境变量。
const String _defaultMysqlUser = '';
const String _defaultMysqlPassword = '';
const String _defaultMysqlHost = '';
const String _defaultMysqlPort = '3306';
const String _defaultMysqlDatabase = '';

String _readEnv(String key, String fallback) {
  final value = Platform.environment[key];
  if (value == null || value.trim().isEmpty) {
    return fallback;
  }
  return value.trim();
}

String buildSettingsYaml() {
  return '''
mysql_user: ${_readEnv('MYSQL_USER', _defaultMysqlUser)}
mysql_password: ${_readEnv('MYSQL_PASSWORD', _defaultMysqlPassword)}
mysql_host: ${_readEnv('MYSQL_HOST', _defaultMysqlHost)}
mysql_port: ${_readEnv('MYSQL_PORT', _defaultMysqlPort)}
mysql_database: ${_readEnv('MYSQL_DATABASE', _defaultMysqlDatabase)}
''';
}
