import 'dart:io';

/// 默认配置。
/// 当运行环境提供同名环境变量时，优先使用环境变量。
const String _defaultMysqlUser = 'root';
const String _defaultMysqlPassword = '';
const String _defaultMysqlHost = 'localhost';
const String _defaultMysqlPort = '3306';
const String _defaultMysqlDatabase = 'fair_pushy';

const String _defaultJwtSecret = 'fair_pushy_secret_key';
const String _defaultJwtExpiry = '24'; // hours

const String _defaultServerPort = '8080';

const String _defaultCdnFileHost = '';
const String _defaultCdnTokenHost = '';
const String _defaultStoragePath = '/opt/fair_storage';

String _readEnv(String key, String fallback) {
  final value = Platform.environment[key];
  if (value == null || value.trim().isEmpty) {
    return fallback;
  }
  return value.trim();
}

String readConfig(String key, String fallback) => _readEnv(key, fallback);

String buildSettingsYaml() {
  return '''
mysql_user: ${_readEnv('MYSQL_USER', _defaultMysqlUser)}
mysql_password: ${_readEnv('MYSQL_PASSWORD', _defaultMysqlPassword)}
mysql_host: ${_readEnv('MYSQL_HOST', _defaultMysqlHost)}
mysql_port: ${_readEnv('MYSQL_PORT', _defaultMysqlPort)}
mysql_database: ${_readEnv('MYSQL_DATABASE', _defaultMysqlDatabase)}
''';
}

class Config {
  static String get mysqlUser => _readEnv('MYSQL_USER', _defaultMysqlUser);
  static String get mysqlPassword => _readEnv('MYSQL_PASSWORD', _defaultMysqlPassword);
  static String get mysqlHost => _readEnv('MYSQL_HOST', _defaultMysqlHost);
  static String get mysqlPort => _readEnv('MYSQL_PORT', _defaultMysqlPort);
  static String get mysqlDatabase => _readEnv('MYSQL_DATABASE', _defaultMysqlDatabase);

  static String get jwtSecret => _readEnv('JWT_SECRET', _defaultJwtSecret);
  static int get jwtExpiryHours => int.tryParse(_readEnv('JWT_EXPIRY_HOURS', _defaultJwtExpiry)) ?? 24;

  static int get serverPort => int.tryParse(_readEnv('SERVER_PORT', _defaultServerPort)) ?? 8080;

  static String get cdnFileHost => _readEnv('CDN_FILE_HOST', _defaultCdnFileHost);
  static String get cdnTokenHost => _readEnv('CDN_TOKEN_HOST', _defaultCdnTokenHost);
  static String get storagePath => _readEnv('STORAGE_PATH', _defaultStoragePath);

  static String get storageType => _readEnv('STORAGE_TYPE', 'local'); // local, oss
  static String get ossEndpoint => _readEnv('OSS_ENDPOINT', '');
  static String get ossBucket => _readEnv('OSS_BUCKET', '');
  static String get ossAccessKey => _readEnv('OSS_ACCESS_KEY', '');
  static String get ossSecretKey => _readEnv('OSS_SECRET_KEY', '');
}
