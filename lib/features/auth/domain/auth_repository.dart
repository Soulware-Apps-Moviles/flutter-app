import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<AuthState> get authStateChanges;
  Future<void> login({required String email, required String password});
  Future<void> logout();
  void dispose();
}