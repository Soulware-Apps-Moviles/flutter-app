import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/you_state.dart';
import 'package:tcompro_customer/features/you/presentation/bloc/your_event.dart';

class YouBloc extends Bloc<YouEvent, YouState> {
  final AuthRepository _authRepository;

  YouBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const YouState()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  FutureOr<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<YouState> emit,
  ) async {
    emit(state.copyWith(status: YouStatus.loading));

    try {
      await _authRepository.logout();
      emit(state.copyWith(status: YouStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: YouStatus.error,
        errorMessage: "Failed to logout: ${e.toString()}",
      ));
    }
  }
}