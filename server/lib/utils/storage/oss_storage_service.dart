import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'storage_service.dart';

class OssStorageService implements StorageService {
  final String endpoint;
  final String bucket;
  final String accessKey;
  final String secretKey;
  final Dio _dio = Dio();

  OssStorageService(this.endpoint, this.bucket, this.accessKey, this.secretKey);

  @override
  Future<String> upload(String fileName, List<int> bytes) async {
    final host = '$bucket.$endpoint';
    final url = 'https://$host';

    // Simple POST Policy for Aliyun OSS
    final policyText = {
      "expiration": "2030-01-01T12:00:00.000Z",
      "conditions": [
        {"bucket": bucket},
        ["content-length-range", 0, 104857600], // 100MB
      ],
    };

    final policyBase64 = base64.encode(utf8.encode(json.encode(policyText)));
    final signature = base64.encode(
      Hmac(
        sha1,
        utf8.encode(secretKey),
      ).convert(utf8.encode(policyBase64)).bytes,
    );

    final formData = FormData.fromMap({
      'key': fileName,
      'policy': policyBase64,
      'OSSAccessKeyId': accessKey,
      'success_action_status': '200',
      'signature': signature,
      'file': MultipartFile.fromBytes(bytes, filename: fileName),
    });

    final response = await _dio.post(url, data: formData);

    if (response.statusCode == 200) {
      return '$url/$fileName';
    } else {
      throw Exception('OSS upload failed: ${response.statusMessage}');
    }
  }

  @override
  Future<void> delete(String fileName) async {
    // Implement delete if needed (requires more complex signature for DELETE request)
  }

  @override
  Future<List<int>> read(String fileName) async {
    final host = '$bucket.$endpoint';
    final url = 'https://$host/$fileName';
    final response = await _dio.get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data as List<int>;
  }
}
