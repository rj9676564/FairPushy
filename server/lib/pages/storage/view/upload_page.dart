import 'dart:io';
import 'package:HotUpdateService/server/src/get_server.dart';
import 'package:HotUpdateService/server/src/context/context_request.dart';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:HotUpdateService/utils/config.dart';
import 'package:HotUpdateService/utils/storage/storage_factory.dart';
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
    
    try {
      final fileUrl = await StorageFactory.i.upload(filename, fileData.data);
      
      // If it's local storage, we still want to prepend the base URL for the web client
      final finalUrl = Config.storageType == 'local' 
          ? '${Config.cdnFileHost.isNotEmpty ? Config.cdnFileHost : "http://localhost:${Config.serverPort}"}/storage/$fileUrl'
          : fileUrl;

      return ResponseSuccess(data: {
        'url': finalUrl,
        'filename': filename,
      });
    } catch (e) {
      return ResponseError(msg: "Upload failed: $e");
    }
  }
}
