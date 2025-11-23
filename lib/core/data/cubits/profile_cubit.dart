// features/auth/presentation/bloc/user_cubit.dart
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/core/constants/api_constants.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/shared/data/profile_service.dart';
import 'package:tcompro_customer/shared/domain/profile.dart';

// Its a bloc-type class that handles the in-memory state of the user's Profile
class UserCubit extends Cubit<Profile?> {
  final AuthRepository _authRepository;
  final ProfileService _profileService;

  UserCubit(this._authRepository, this._profileService) : super(null) {
    _monitorAuthState();
  }

  void _monitorAuthState() {
    _authRepository.authStateChanges.listen((state) async {
      if (state.session != null) {
        try {
          final uuid = state.session!.user.id;
          final profile = await _profileService.fetchProfile(authId: uuid, role: ApiConstants.customerRole);
          
          emit(profile);
        } catch (e) {
          debugPrint("Error cargando perfil: $e");
        }
      } else {
        emit(null);
      }
    });
  }
}