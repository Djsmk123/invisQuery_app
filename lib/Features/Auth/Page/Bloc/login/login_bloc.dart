import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:invisquery/Features/Auth/Data/Models/auth_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepoImpl authRepo;
  LoginBloc(this.authRepo) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is LoginPasswordBasedEvent) {
        emit(const LoginLoading(LoginStates.basic));
        final res = !event.isNewAccount
            ? await authRepo.login(event.email, event.password, event.fcmToken)
            : (await authRepo.signUp(
                event.email, event.password, event.fcmToken));
        if (res.$1 != null) {
          emit(FailureLogin(LoginStates.basic, res.$1!));
        } else {
          emit(LoginSuccess(LoginStates.basic, res.$2!));
        }
      }
      if (event is AnonLogin) {
        emit(const LoginLoading(LoginStates.basic));
        final res = await authRepo.anonymous(event.fcmToken);
        if (res.$1 != null) {
          emit(FailureLogin(LoginStates.anonymousLogin, res.$1!));
        } else {
          emit(LoginSuccess(LoginStates.anonymousLogin, res.$2!));
        }
      }
      if (event is ResetPasswordEvent) {
        emit(const LoginLoading(LoginStates.forgotPassword));
        final res = await authRepo.resetPassword(event.email);
        if (res == null) {
          emit(LoginPasswordResetSuccess());
        } else {
          emit(FailureLogin(LoginStates.forgotPassword, res));
        }
      }
    });
  }
}
