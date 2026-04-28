import 'dart:io';

abstract class StorageService {
  /// Uploads a file and returns its public URL
  Future<String> upload(String fileName, List<int> bytes);

  /// Deletes a file
  Future<void> delete(String fileName);

  /// Serves a file (mainly for local storage)
  Future<List<int>> read(String fileName);
}
