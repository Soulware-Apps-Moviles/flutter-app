import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcompro_customer/core/data/cubits/token_cubit.dart';
import 'package:tcompro_customer/features/auth/data/auth_service.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final TokenCubit _tokenCubit;
  StreamSubscription? _authSubscription;

  AuthRepositoryImpl({required AuthService authService, required TokenCubit tokenCubit}) : _authService = authService, _tokenCubit = tokenCubit {
    _authSubscription = _authService.authStateChanges.listen((data) {
      final event = data.event;
      final session = data.session;

      switch (event) {
        // Both imply setting the accessToken to a new value
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.tokenRefreshed:
          if (session != null) {
            _tokenCubit.setToken(session.accessToken);
          }
          break;

        case AuthChangeEvent.signedOut:
          _tokenCubit.setToken(null);
          break;

        default:
          break;
      }
    });
  }
  
  @override
  User? get currentUser => _authService.currentUser;

  @override
  Stream<AuthState> get authStateChanges => _authService.authStateChanges;

  @override
  Future<void> login({required String email, required String password}) async {
    await _authService.login(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
  }
}