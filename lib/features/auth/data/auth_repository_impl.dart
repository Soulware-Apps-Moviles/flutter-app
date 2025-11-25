import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tcompro_customer/core/data/cubits/token_cubit.dart';
import 'package:tcompro_customer/features/auth/data/auth_service.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/shared/data/profile_service.dart';
import 'package:tcompro_customer/shared/domain/profile.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final TokenCubit _tokenCubit;
  final ProfileService _profileService;
  StreamSubscription? _authSubscription;

  AuthRepositoryImpl({
    required AuthService authService, 
    required TokenCubit tokenCubit,
    required ProfileService profileService,
  }) : 
    _authService = authService, _tokenCubit = tokenCubit, _profileService = profileService {
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
  Future<Profile> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone
  }) async {
    final authResponse = await _authService.register(email: email, password: password);
    final String? authId = authResponse.user?.id;

    if (authId == null) {
      throw Exception('Error obtaining supabase authId from recently registered user.');
    }
    
    return await _profileService.uploadProfile(
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone
    );
  }

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