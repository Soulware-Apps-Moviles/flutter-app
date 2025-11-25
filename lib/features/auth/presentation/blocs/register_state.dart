import 'package:tcompro_customer/shared/domain/profile.dart'; // Ajusta según tu modelo

enum RegisterStatus { initial, loading, success, failure, invalid }

class RegisterState {
  final String firstName;
  final String lastName;
  final String email;
  final String phonePrefix;
  final String phone;
  final String password;
  final String confirmationPassword;
  final bool isPasswordVisible;
  final RegisterStatus status;
  final String? message;
  final Profile? registeredProfile;
  final int currentStep;

  const RegisterState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phonePrefix = '',
    this.phone = '',
    this.password = '',
    this.confirmationPassword = '',
    this.isPasswordVisible = false,
    this.status = RegisterStatus.initial,
    this.message,
    this.registeredProfile,
    this.currentStep = 0,
  });

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phonePrefix,
    String? phone,
    String? password,
    String? confirmationPassword,
    bool? isPasswordVisible,
    RegisterStatus? status,
    String? message,
    Profile? registeredProfile,
    int? currentStep,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phonePrefix: phonePrefix ?? this.phonePrefix,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      confirmationPassword: confirmationPassword ?? this.confirmationPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      status: status ?? this.status,
      message: message ?? this.message,
      registeredProfile: registeredProfile ?? this.registeredProfile,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}