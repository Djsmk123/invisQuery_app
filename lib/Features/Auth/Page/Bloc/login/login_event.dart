part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginPasswordBasedEvent extends LoginEvent {
  final String password;
  final String email;
  final String? fcmToken;
  const LoginPasswordBasedEvent(
      {required this.password, required this.email, this.fcmToken});
  @override
  List<Object?> get props => [password, email, fcmToken];
}

class ResetPasswordEvent extends LoginEvent {
  final String email;
  const ResetPasswordEvent(this.email);
  @override
  List<Object?> get props => [];
}
