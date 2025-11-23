import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Its a bloc-type class that handles the in-memory state of the Token
// Implements both state sharing operations (emit) and storage operations (load, set)
// This allows to bootstrap the in memory state of the token even after closing the app
class TokenCubit extends Cubit<String?> {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  TokenCubit() : _storage = const FlutterSecureStorage(), super(null) {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final token = await _storage.read(key: _tokenKey);
    emit(token);
  }

  Future<void> setToken(String? token) async {
    if (token != null) {
      await _storage.write(key: _tokenKey, value: token);
    } else {
      await _storage.delete(key: _tokenKey);
    }
    emit(token);
  }
}