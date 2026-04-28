import 'package:HotUpdateService/pages/user/data/data_model/user_model.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

class UserDao extends Dao<User> {
  UserDao() : super(tablename);
  UserDao.withDb(Db db) : super.withDb(db, tablename);

  static String get tablename => 'user';

  @override
  User fromRow(Row row) => User.fromRow(row);

  Future<User?> getByUsername(String username) async {
    final rows = await query('select * from $tablename where username = ?', [username]);
    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<User?> getByUserId(int userId) async {
    final rows = await query('select * from $tablename where user_id = ?', [userId]);
    if (rows.isEmpty) return null;
    return rows.first;
  }
}
