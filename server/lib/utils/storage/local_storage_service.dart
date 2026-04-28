import 'dart:io';
import 'package:path/path.dart' as p;
import '../config.dart';
import 'storage_service.dart';

class LocalStorageService implements StorageService {
  final String _basePath;

  LocalStorageService(this._basePath) {
    final dir = Directory(_basePath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  @override
  Future<String> upload(String fileName, List<int> bytes) async {
    final filePath = p.join(_basePath, fileName);
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    
    // Return relative URL or full URL if domain is known
    // For now, we'll return the filename and let the server handle mapping
    return fileName; 
  }

  @override
  Future<void> delete(String fileName) async {
    final filePath = p.join(_basePath, fileName);
    final file = File(filePath);
    if (file.existsSync()) {
      await file.delete();
    }
  }

  @override
  Future<List<int>> read(String fileName) async {
    final filePath = p.join(_basePath, fileName);
    final file = File(filePath);
    if (file.existsSync()) {
      return await file.readAsBytes();
    }
    throw Exception('File not found: $fileName');
  }
}
