import 'package:simple_mysql_orm/simple_mysql_orm.dart';

class User extends Entity<User> {
  factory User({
    required int userId,
    required String username,
    required String password,
    String? role,
    String? createTime,
    String? updateTime,
  }) =>
      User._internal(
        userId: userId,
        username: username,
        password: password,
        role: role ?? 'user',
        createTime: createTime ?? DateTime.now().toString(),
        updateTime: updateTime ?? DateTime.now().toString(),
      );

  factory User.fromRow(Row row) {
    return User._internal(
      userId: row.fieldAsInt('user_id'),
      username: row.fieldAsString('username'),
      password: row.fieldAsString('password'),
      role: row.fieldAsString('role'),
      createTime: row.fieldAsString('create_time'),
      updateTime: row.fieldAsString('update_time'),
    );
  }

  User._internal({
    required this.userId,
    required this.username,
    required this.password,
    this.role,
    this.createTime,
    this.updateTime,
  }) : super(userId);

  late int userId;
  late String username;
  late String password;
  late String? role;
  late String? createTime;
  late String? updateTime;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'role': role,
        'createTime': createTime,
        'updateTime': updateTime,
      };

  @override
  FieldList get fields => [
        'user_id',
        'username',
        'password',
        'role',
        'create_time',
        'update_time',
      ];

  @override
  ValueList get values => [
        userId,
        username,
        password,
        role,
        createTime,
        updateTime,
      ];
}
