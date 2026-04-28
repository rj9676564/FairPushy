import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/utils/auth_utils.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

/*
* 参数处理的基类
* Created by Wang Meng on 2022/4/11.
* Copyright © 2020 58. All rights reserved.
* */
abstract class FairServiceWidget extends GetView {
  @override
  Widget build(BuildContext context) {
    try {
      return FutureBuilder(
          future: this.requestHandler(context.request),
          builder: (context, snapshot) {
            if (snapshot?.connectionState == ConnectionState.done) {
              return Success(data: snapshot?.data);
            } else {
              return WidgetEmpty();
            }
          });
    } catch (e) {
      return Error(error: e.toString());
    }
  }

  /**
   * 处理不同请求的参数
   */
  Future<Map<String, dynamic>> requestHandler(ContextRequest req) async {
    Map? payload;
    if (req.requestMethod == Method.get) {
      payload = req.uri.queryParameters;
    } else if (req.requestMethod == Method.post) {
      payload = await req.payload();
    } else {
      payload = req.uri.queryParameters;
    }
    
    final response = await service(payload);
    return response.toJson();
  }

  Future<ResponseBaseModel> service(Map? request_params);
}

abstract class AuthenticatedFairServiceWidget extends FairServiceWidget {
  JwtClaim? _authClaim;
  JwtClaim? get authClaim => _authClaim;

  @override
  Future<Map<String, dynamic>> requestHandler(ContextRequest req) async {
    final authHeader = req.header('Authorization');
    if (authHeader == null || authHeader.isEmpty) {
      return ResponseError(msg: 'Missing Authorization header', code: '401').toJson();
    }

    final token = authHeader.first.replaceFirst('Bearer ', '');
    _authClaim = AuthUtils.verifyJwt(token);

    if (_authClaim == null) {
      return ResponseError(msg: 'Invalid or expired token', code: '401').toJson();
    }

    return super.requestHandler(req);
  }
}
