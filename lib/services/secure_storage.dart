import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService  {
    final _secureStorage = const FlutterSecureStorage();
    AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

    IOSOptions _getIOSOptions() => const IOSOptions(
      accessibility: IOSAccessibility.first_unlock
    );

    Future<void> write(key, value) async {
      await _secureStorage.write(key: key, value: value,  aOptions: _getAndroidOptions(),
          iOptions: _getIOSOptions());
    }

    Future<String?> read(String key) async {
      return await _secureStorage.read(key: key, aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions());
    }

    Future<void> delete(key) async {
      await _secureStorage.delete(key: key, aOptions: _getAndroidOptions(),
       iOptions: _getIOSOptions());
    }
}