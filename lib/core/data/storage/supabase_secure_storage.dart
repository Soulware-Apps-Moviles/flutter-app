import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Implements Supabase storage interface using secure storage to safely persist session data
// Supabase already is able to persist data without a problem, but it does it without any encryption
// This adaptar only purpose is allow to store the session token and refresh token safely
class SupabaseSecureStorage extends LocalStorage {
  final _storage = const FlutterSecureStorage();
  static const _legacyKey = 'supabase_persist_session';

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() async {
    return _storage.read(key: _legacyKey);
  }

  @override
  Future<bool> hasAccessToken() async {
    return _storage.containsKey(key: _legacyKey);
  }

  @override
  Future<void> persistSession(String persistSessionString) async {
    await _storage.write(key: _legacyKey, value: persistSessionString);
  }

  @override
  Future<void> removePersistedSession() async {
    await _storage.delete(key: _legacyKey);
  }
}