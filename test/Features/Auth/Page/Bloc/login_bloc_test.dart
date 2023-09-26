import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:invisquery/Features/Auth/Data/Models/auth_model.dart';
import 'package:invisquery/Features/Auth/Page/Bloc/login/login_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../Data/DataSource/auth_repo_impl_test.dart';
import 'login_bloc_test.mocks.dart';

@GenerateMocks([AuthRepoImpl])
void main() {
  late MockAuthRepoImpl mockAuthRepo;
  late LoginBloc loginBloc;
  setUp(() {
    mockAuthRepo = MockAuthRepoImpl();
    loginBloc = LoginBloc(mockAuthRepo);
  });

  group('LoginBloc', () {
    late String email;
    late String password;
    late String fcmToken;
    setUp(() {
      email = 'test@example.com';
      password = 'password';
      fcmToken = 'fcmToken';
    });
    AuthModel authModel = AuthModel.fromJson(authValidJson());
    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, LoginSuccess] when successful login',
      build: () {
        when(mockAuthRepo.login(email, password, fcmToken))
            .thenAnswer((_) async => (null, authModel));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginPasswordBasedEvent(
        email: email,
        password: password,
        fcmToken: fcmToken,
        isNewAccount: false,
      )),
      expect: () => [
        const LoginLoading(LoginStates.basic),
        LoginSuccess(LoginStates.basic, authModel),
      ],
    );

    blocTest<LoginBloc, LoginState>(
      'emits [LoginLoading, FailureLogin] when login fails',
      build: () {
        when(mockAuthRepo.login(email, password, fcmToken)).thenAnswer(
            (_) async =>
                (const EndpointFailure(message: "invalid credential"), null));
        return loginBloc;
      },
      act: (bloc) => bloc.add(LoginPasswordBasedEvent(
        email: email,
        password: password,
        fcmToken: fcmToken,
        isNewAccount: false,
      )),
      expect: () => [
        const LoginLoading(LoginStates.basic),
        const FailureLogin(
            LoginStates.basic, EndpointFailure(message: "invalid credential")),
      ],
    );
  });

  tearDown(() {
    loginBloc.close();
  });
}
