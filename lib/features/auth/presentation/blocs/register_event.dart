abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterFirstNameChanged extends RegisterEvent {
  final String firstName;
  const RegisterFirstNameChanged(this.firstName);
}

class RegisterLastNameChanged extends RegisterEvent {
  final String lastName;
  const RegisterLastNameChanged(this.lastName);
}

class RegisterEmailChanged extends RegisterEvent {
  final String email;
  const RegisterEmailChanged(this.email);
}

class RegisterPhonePrefixChanged extends RegisterEvent {
  final String phonePrefix;
  const RegisterPhonePrefixChanged(this.phonePrefix);
}

class RegisterPhoneChanged extends RegisterEvent {
  final String phone;
  const RegisterPhoneChanged(this.phone);
}

class RegisterPasswordChanged extends RegisterEvent {
  final String password;
  const RegisterPasswordChanged(this.password);
}

class RegisterConfirmationPasswordChanged extends RegisterEvent {
  final String confirmationPassword;
  const RegisterConfirmationPasswordChanged(this.confirmationPassword);
}

class RegisterTogglePasswordVisibility extends RegisterEvent {
  const RegisterTogglePasswordVisibility();
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted();
}

class RegisterStepContinue extends RegisterEvent {
  const RegisterStepContinue();
}

class RegisterStepCancel extends RegisterEvent {
  const RegisterStepCancel();
}

class RegisterStepTapped extends RegisterEvent {
  final int step;
  const RegisterStepTapped(this.step);
}