import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:HotUpdateService/utils/config.dart';

class AuthUtils {
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static String generateJwt(int userId, String username, String role) {
    final claimSet = JwtClaim(
      subject: userId.toString(),
      issuer: 'fair_pushy',
      expiry: DateTime.now().add(Duration(hours: Config.jwtExpiryHours)),
      payload: {
        'username': username,
        'role': role,
      },
    );

    return issueJwtHS256(claimSet, Config.jwtSecret);
  }

  static JwtClaim? verifyJwt(String token) {
    try {
      return verifyJwtHS256Signature(token, Config.jwtSecret);
    } catch (e) {
      return null;
    }
  }
}
