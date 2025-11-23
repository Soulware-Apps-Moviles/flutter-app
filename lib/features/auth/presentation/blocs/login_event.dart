abstract class LoginEvent {
  const LoginEvent();
}

class EmailChanged extends LoginEvent {
  final String email;
  const EmailChanged({required this.email});
}

class PasswordChanged extends LoginEvent {
  final String password;
  const PasswordChanged({required this.password});
}

class TogglePasswordVisibility extends LoginEvent {
  const TogglePasswordVisibility();
}

class Login extends LoginEvent {
  const Login();
}