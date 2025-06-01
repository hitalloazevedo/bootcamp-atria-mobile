import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();
  static const String _tokenChave = 'user_token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenChave, value: token);
    print("Token Salvo!");
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenChave);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenChave);
    print("Token deletado!");
  }
}
