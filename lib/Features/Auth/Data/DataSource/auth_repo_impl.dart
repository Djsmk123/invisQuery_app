import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/parser.dart';
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:invisquery/Features/Auth/Data/Models/auth_model.dart';
import 'package:invisquery/Features/Auth/Data/Models/user_model.dart';
import 'package:invisquery/Features/Auth/Domain/Reposatiory/auth_repo.dart';
import 'package:invisquery/Features/Auth/Domain/Reposatiory/auth_use_cases.dart';

class AuthRepoImpl extends AuthRepo {
  final NetworkServiceImpl networkService;
  final StorageService storageService;

  AuthRepoImpl(this.networkService, this.storageService);

  @override
  Future<(Failure?, AuthModel?)> login(
      String email, String password, String? fcmToken) async {
    return loginHelper(
      useCase: AuthUseCase.login,
      endpoint: '/login',
      password: password,
      fcmToken: fcmToken,
      email: email,
    );
  }

  @override
  Future<(Failure?, AuthModel?)> anonymous(String? fcmToken) {
    return loginHelper(
      useCase: AuthUseCase.anonymousLogin,
      endpoint: '/create-ano-user',
      fcmToken: fcmToken,
    );
  }

  @override
  Future<Failure?> deleteUser() async {
    final res = await networkService.get(endpoint: '/delete-user');
    if (res.$1 != null) {
      return (res.$1);
    }
    final storage = logoutHelper();
    return (storage);
  }

  @override
  Future<(Failure?, UserModel?)> getUser() async {
    final res = await networkService.get(endpoint: '/get-user');
    if (res.$1 != null) {
      return (res.$1, null);
    }
    JsonObjectUtils<UserModel> utils = JsonObjectUtils<UserModel>();
    final obj = utils.jsonToObject(() => UserModel.fromJson(res.$2!.data));
    if (obj.$1 != null) {
      return (res.$1, null);
    }
    user = obj.$2;
    return (null, obj.$2);
  }

  @override
  Future<Failure?> logout() async {
    final res = await networkService.post(endpoint: '/logout', data: {});
    if (res.$1 != null) {
      return (res.$1);
    }
    final storage = logoutHelper();
    return (storage);
  }

  @override
  Future<Failure?> resetPassword(String email) async {
    final res = await networkService
        .post(endpoint: '/request-password-reset', data: {'email': email});
    return (res.$1);
  }

  @override
  Future<(Failure?, AuthModel?)> signUp(
      String email, String password, String? fcmToken) {
    return loginHelper(
      useCase: AuthUseCase.signUp,
      endpoint: '/create-user',
      fcmToken: fcmToken,
      password: password,
      email: email,
    );
  }

  @override
  Future<(Failure?, AuthModel?)> socialLogin(String email, String provider,
      String? privateProfileImage, String? fcmToken) {
    return loginHelper(
      useCase: AuthUseCase.socialLogin,
      endpoint: '/social-login',
      fcmToken: fcmToken,
      provider: provider,
      privateProfileImage: privateProfileImage,
      email: email,
    );
  }

  Future<(Failure?, AuthModel?)> loginHelper({
    required AuthUseCase useCase,
    required String endpoint,
    String? email,
    String? password,
    String? fcmToken,
    String? provider,
    String? privateProfileImage,
  }) async {
    Map<String, dynamic> body = {};
    if (fcmToken != null) {
      body['fcm_token'] = fcmToken;
    }
    switch (useCase) {
      case AuthUseCase.login:
        body = {
          'email': email,
          'password': password,
        };

        break;
      case AuthUseCase.signUp:
        body = {
          'email': email,
          'password': password,
        };

        break;
      case AuthUseCase.anonymousLogin:
        break;
      case AuthUseCase.socialLogin:
        body = {
          'email': email,
          'provider': provider,
          'private_profile_image': privateProfileImage
        };
        break;
      default:
        {
          return (const ServiceError(), null);
        }
    }

    if (fcmToken != null) {
      body["fcm_token"] = fcmToken;
    }

    final res = await networkService.post(endpoint: endpoint, data: body);
    if (res.$1 != null) {
      return (res.$1, null);
    }

    JsonObjectUtils<AuthModel> utils = JsonObjectUtils<AuthModel>();
    (Failure?, AuthModel?) obj =
        utils.jsonToObject(() => AuthModel.fromJson(res.$2!.data));

    if (obj.$1 != null) {
      return (obj.$1, null);
    }
    user = obj.$2?.user;
    return (null, obj.$2);
  }

  @override
  String? accessToken;

  @override
  Future<(Failure?, String?)> getAccessToken() async {
    if (accessToken != null) {
      return (null, accessToken);
    }
    final res = await storageService.readStorage('access_token');
    if (res.$1 != null) {
      return (res.$1, null);
    }
    accessToken = res.$2;
    return (null, res.$2);
  }

  Future<Failure?> logoutHelper() {
    accessToken = null;
    user = null;
    return storageService.deleteAll();
  }

  @override
  UserModel? user;
}
