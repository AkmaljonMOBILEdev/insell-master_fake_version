import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final _storage = const FlutterSecureStorage();

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> deleteKeys(List list) async {
    for (var i = 0; i < list.length; i++) {
      await _storage.delete(key: list[i]);
    }
  }
}
