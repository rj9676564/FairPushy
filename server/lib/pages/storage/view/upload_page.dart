import 'dart:io';
import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:HotUpdateService/utils/config.dart';
import 'package:path/path.dart' as p;

class UploadPage extends AuthenticatedFairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    final fileData = request_params?['file'];
    if (fileData == null) {
      return ParamsError(msg: "No file uploaded");
    }

    // In GetServer, multipart file is usually a MultipartUpload object
    // Based on context_request.dart, payload[name] = data where data is MultipartUpload if filename exists
    
    if (fileData is! MultipartUpload) {
      return ResponseError(msg: "Invalid file data");
    }

    final filename = fileData.name ?? 'uploaded_file_${DateTime.now().millisecondsSinceEpoch}';
    final directory = Directory(Config.storagePath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    final filePath = p.join(Config.storagePath, filename);
    final file = File(filePath);
    await file.writeAsBytes(fileData.data);

    final baseUrl = Config.cdnFileHost.isNotEmpty ? Config.cdnFileHost : 'http://localhost:${Config.serverPort}';
    final fileUrl = '$baseUrl/storage/$filename';

    return ResponseSuccess(data: {
      'url': fileUrl,
      'filename': filename,
    });
  }
}
