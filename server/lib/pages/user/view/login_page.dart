import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:HotUpdateService/utils/auth_utils.dart';
import '../data/data_dao/user_model_dao.dart';
import '../data/data_model/user_model.dart';
import 'package:simple_mysql_orm/simple_mysql_orm.dart';

class LoginPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final username = request_params?['username'];
    final password = request_params?['password'];

    if (username == null || password == null) {
      return ParamsError(msg: 'Username and password are required');
    }

    User? user;
    try {
      await withTransaction<void>(() async {
        final dao = UserDao();
        user = await dao.getByUsername(username);
      });
    } catch (e) {
      return ResponseError(msg: e.toString());
    }

    if (user == null) {
      return ResponseError(msg: 'User not found');
    }

    if (user.password != AuthUtils.hashPassword(password)) {
      return ResponseError(msg: 'Invalid password');
    }

    final token = AuthUtils.generateJwt(user.userId, user.username, user.role ?? 'user');

    return ResponseSuccess(data: {
      'token': token,
      'user': user.toJson(),
    });
  }
}

class RegisterPage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final username = request_params?['username'];
    final password = request_params?['password'];
    final role = request_params?['role'] ?? 'user';

    if (username == null || password == null) {
      return ParamsError(msg: 'Username and password are required');
    }

    try {
      int? userId;
      await withTransaction<void>(() async {
        final dao = UserDao();
        final existingUser = await dao.getByUsername(username);
        if (existingUser != null) {
          throw Exception('Username already exists');
        }

        final newUser = User(
          userId: 0,
          username: username,
          password: AuthUtils.hashPassword(password),
          role: role,
        );
        userId = await dao.persist(newUser);
      });
      return ResponseSuccess(data: {'userId': userId});
    } catch (e) {
      final message = e.toString();
      if (message.contains('Username already exists')) {
        return ResponseError(msg: 'Username already exists');
      }
      return ResponseError(msg: message);
    }
  }
}
