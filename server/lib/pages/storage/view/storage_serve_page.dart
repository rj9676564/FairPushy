import 'dart:io';
import 'package:HotUpdateService/server/fair_server_response.dart';
import 'package:HotUpdateService/server/fair_server_widget.dart';
import 'package:HotUpdateService/utils/config.dart';
import 'package:path/path.dart' as p;
import 'package:HotUpdateService/utils/storage/storage_factory.dart';

class StorageServePage extends FairServiceWidget {
  @override
  Future<ResponseBaseModel> service(Map? request_params) async {
    // This method won't be used because we'll override requestHandler
    return ResponseError();
  }

  @override
  Future<Map<String, dynamic>> requestHandler(ContextRequest req) async {
    final filename = req.param('filename');
    if (filename == null) {
      return ResponseError(msg: 'Filename missing').toJson();
    }
    try {
      final bytes = await StorageFactory.i.read(filename);
      req.response?.sendBytes(bytes);
      return {}; 
    } catch (e) {
      return ResponseError(msg: 'File not found: $e', code: 404).toJson();
    }
  }
}
