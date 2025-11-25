import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcompro_customer/shared/domain/profile.dart';

abstract class AuthRepository {
  User? get currentUser;
  Stream<AuthState> get authStateChanges;
  Future<Profile> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
  });
  Future<void> login({required String email, required String password});
  Future<void> logout();
  void dispose();
}