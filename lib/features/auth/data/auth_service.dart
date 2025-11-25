import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient;

  AuthService(this._supabaseClient);

  Stream<AuthState> get authStateChanges => _supabaseClient.auth.onAuthStateChange;

  User? get currentUser => _supabaseClient.auth.currentUser;

  Future<AuthResponse> register({required String email, required String password}) async {
    return await _supabaseClient.auth.signUp(email: email, password: password);
  }

  Future<void> login({required String email, required String password}) async {
    await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await _supabaseClient.auth.signOut();
  }
}