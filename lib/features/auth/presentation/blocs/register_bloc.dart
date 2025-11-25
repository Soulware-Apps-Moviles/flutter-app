import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcompro_customer/features/auth/domain/auth_repository.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_event.dart';
import 'package:tcompro_customer/features/auth/presentation/blocs/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository _authRepository;

  RegisterBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const RegisterState()) {
    on<RegisterFirstNameChanged>(_onFirstNameChanged);
    on<RegisterLastNameChanged>(_onLastNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmationPasswordChanged>(_onConfirmationPasswordChanged);
    on<RegisterPhonePrefixChanged>(_onPhonePrefixChanged);
    on<RegisterPhoneChanged>(_onPhoneChanged);
    on<RegisterTogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<RegisterSubmitted>(_onSubmitted);
    on<RegisterStepContinue>(_onStepContinue);
    on<RegisterStepCancel>(_onStepCancel);
    on<RegisterStepTapped>(_onStepTapped);
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^[0-9]{7,15}$'); // ISO format that the backend service expects to receive
    return phoneRegExp.hasMatch(phone);
  }

  bool _isPasswordSecure(String password) {
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]'));
  }

  void _onFirstNameChanged(
      RegisterFirstNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        firstName: event.firstName, status: RegisterStatus.initial));
  }

  void _onLastNameChanged(
      RegisterLastNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        lastName: event.lastName, status: RegisterStatus.initial));
  }

  void _onEmailChanged(
      RegisterEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: event.email, status: RegisterStatus.initial));
  }

  void _onPasswordChanged(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        password: event.password, status: RegisterStatus.initial));
  }

  void _onConfirmationPasswordChanged(
      RegisterConfirmationPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(
        confirmationPassword: event.confirmationPassword,
        status: RegisterStatus.initial));
  }

  void _onPhoneChanged(
      RegisterPhoneChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(phone: event.phone, status: RegisterStatus.initial));
  }

  void _onPhonePrefixChanged(
      RegisterPhonePrefixChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(phonePrefix: event.phonePrefix, status: RegisterStatus.initial));
  }

  void _onTogglePasswordVisibility(
      RegisterTogglePasswordVisibility event, Emitter<RegisterState> emit) {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  void _onStepContinue(RegisterStepContinue event, Emitter<RegisterState> emit) {
    switch (state.currentStep) {
      case 0: 
        if (state.firstName.trim().isEmpty || state.lastName.trim().isEmpty) {
          emit(state.copyWith(
            status: RegisterStatus.invalid,
            message: "First name and last name are required.",
          ));
          return;
        }
        emit(state.copyWith(currentStep: state.currentStep + 1, status: RegisterStatus.initial));
        break;
      case 1:
        if (!_isValidEmail(state.email)) {
          emit(state.copyWith(
            status: RegisterStatus.invalid,
            message: "Please enter a valid email address.",
          ));
          return;
        }
        if (state.phone.trim().isEmpty || !_isValidPhone(state.phone)) {
          emit(state.copyWith(
            status: RegisterStatus.invalid,
            message: "Please enter a valid phone number (digits only).",
          ));
          return;
        }
        emit(state.copyWith(currentStep: state.currentStep + 1, status: RegisterStatus.initial));
        break;
      case 2: 
        add(const RegisterSubmitted());
        break;
      default:
        throw Exception("Unexpected step value");
    }
  }

  void _onStepCancel(RegisterStepCancel event, Emitter<RegisterState> emit) {
    if (state.currentStep > 0) {
      emit(state.copyWith(
          currentStep: state.currentStep - 1, status: RegisterStatus.initial));
    }
  }

  void _onStepTapped(RegisterStepTapped event, Emitter<RegisterState> emit) {
    if (event.step < state.currentStep) {
      emit(state.copyWith(
          currentStep: event.step, status: RegisterStatus.initial));
    }
  }

  Future<void> _onSubmitted(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    if (!_isPasswordSecure(state.password)) {
      emit(state.copyWith(
        status: RegisterStatus.invalid,
        message: "Password must be at least 8 chars, include an uppercase and a number.",
      ));
      return;
    }

    if (state.password != state.confirmationPassword) {
      emit(state.copyWith(
        status: RegisterStatus.invalid,
        message: "Passwords do not match.",
      ));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      final profile = await _authRepository.register(
        firstName: state.firstName.trim(),
        lastName: state.lastName.trim(),
        email: state.email.trim(),
        password: state.password,
        phone: "${state.phonePrefix}${state.phone.trim()}",
      );

      emit(state.copyWith(
        status: RegisterStatus.success,
        registeredProfile: profile,
        message: "Account created successfully!",
      ));
    } catch (e) {
      String errorMessage = "Registration failed. Please try again.";
      emit(state.copyWith(
        status: RegisterStatus.failure,
        message: errorMessage,
      ));
    }
  }
}