import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_event.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/login_state.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({required AuthRepository authRepository}) : _authRepository = authRepository, super(const LoginState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<Login>(_onLogin);
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      email: event.email,
      status: LoginStatus.initial,
    ));
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      password: event.password,
      status: LoginStatus.initial,
    ));
  }

  void _onTogglePasswordVisibility(TogglePasswordVisibility event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      isPasswordVisible: !state.isPasswordVisible
    ));
  }

  Future<void> _onLogin(Login event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading)); 

    try {
      await _authRepository.login(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(status: LoginStatus.success)); 
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        message: e.toString(), 
      ));
    }
  }
}