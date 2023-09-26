import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:invisquery/Features/Auth/Data/Models/auth_model.dart';
import 'package:invisquery/Features/Auth/Data/Models/user_model.dart';
import 'package:mockito/mockito.dart';

import '../../../../Core/Network/network_test.mocks.dart';
import '../../../../Core/utils/mock_response.dart';
import '../../../../Core/utils/storage_test.mocks.dart';

void main() {
  late AuthRepoImpl authRepo;
  late MockInternetConnectionCheckerPlus mockInternetConnectionChecker;
  late APIInfo apiInfo;
  late MockHttpWithMiddleware mockClient;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late NetworkServiceImpl networkServiceImpl;
  late StorageService storageService;
  late String tEndpoint;
  late String fcmToken;
  late String tToken;
  late Uri url;
  void mockPostResponse(Map<String, dynamic> tBody, Response response,
      {Map<String, String>? headers}) {
    when(mockClient.post(
      url,
      headers: headers ?? apiInfo.defaultHeader,
      body: jsonEncode(tBody),
    )).thenAnswer((v) async => response);
  }

  void mockGetResponse(Response response,
      {Map<String, String>? headers, Map<String, String>? query}) {
    if (query != null) {
      url = url.replace(queryParameters: query);
    }
    /*print(url.toString() + headers.toString() + response.body.toString());*/
    when(mockClient.get(
      url,
      headers: headers ?? apiInfo.defaultHeader,
    )).thenAnswer((v) async => response);
  }

  void mockStorageWriteToken(String tToken) {
    when(mockFlutterSecureStorage.write(key: 'token', value: tToken))
        .thenAnswer((_) => Future.value());
  }

  void mockStorageReadToken() {
    when(mockFlutterSecureStorage.read(key: "token"))
        .thenAnswer((_) => Future.value());
  }

  void mockStorageDeleteToken() {
    when(mockFlutterSecureStorage.deleteAll())
        .thenAnswer((_) => Future.value());
  }

  Future<(Failure?, AuthModel?)> performLogin(
    Uri url,
    String email,
    String password,
    String? fcmToken,
    Response response,
  ) async {
    Map<String, dynamic> tBody = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };
    mockStorageWriteToken(tToken);
    mockPostResponse(tBody, response);

    return await authRepo.login(email, password, fcmToken);
  }

  Future<(Failure?, AuthModel?)> performAnonLogin(
    Uri url,
    String? fcmToken,
    Response response,
  ) async {
    Map<String, dynamic> tBody = {};

    if (fcmToken != null) {
      tBody['fcm_token'] = fcmToken;
    }
    mockPostResponse(tBody, response);

    return await authRepo.anonymous(fcmToken);
  }

  Future<(Failure?, AuthModel?)> performUserCreation(
    Uri url,
    String email,
    String password,
    String? fcmToken,
    Response response,
  ) async {
    Map<String, dynamic> tBody = {
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
    };

    mockStorageWriteToken(tToken);
    mockPostResponse(tBody, response);

    return await authRepo.signUp(email, password, fcmToken);
  }

  Future<(Failure?, AuthModel?)> performSocialLogin(
    Uri url,
    String email,
    String provider,
    String? privateProfileImage,
    String? fcmToken,
    Response response,
  ) async {
    Map<String, dynamic> tBody = {
      'email': email,
      'provider': provider,
      'private_profile_image': privateProfileImage
    };
    if (fcmToken != null) {
      tBody['fcm_token'] = fcmToken;
    }

    mockPostResponse(tBody, response);

    return await authRepo.socialLogin(
        email, provider, privateProfileImage, fcmToken);
  }

  void authSuccessExpection((Failure?, AuthModel?) result) {
    expect(result.$1, isNull);
    expect(result.$2, isNotNull);
    expect(result.$2!.accessToken, equals(authValidJson()['token']));
    expect(result.$2!.toJson(), equals(authValidJson()));
    expect(result.$2!.user.toJson(), equals(authValidJson()['user']));
  }

  void authInvalidResponseExpection((Failure?, AuthModel?) result) {
    expect(result.$1, isNotNull);
    expect(result.$2, isNull);
    expect(result.$1, isA<JsonDecodeFailure>());
  }

  void authFailureResponseExpection(
      (Failure?, AuthModel?) result, String message) {
    expect(result.$1, isNotNull);
    expect(result.$1, isA<EndpointFailure>());
    expect(result.$1!.message, equals(message));
  }

  setUpAll(() {
    fcmToken = "fcmToken";
    tToken = "token";
    // Initialize the AuthRepoImpl with mock dependencies or test-specific ones.
    mockInternetConnectionChecker = MockInternetConnectionCheckerPlus();
    apiInfo = APIInfo();
    mockClient = MockHttpWithMiddleware();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    networkServiceImpl =
        NetworkServiceImpl(mockInternetConnectionChecker, mockClient);
    storageService = StorageService(mockFlutterSecureStorage);
    authRepo = AuthRepoImpl(networkServiceImpl, storageService);
    when(mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => true);
  });
  group('login-user', () {
    late String email;
    late String password;
    setUpAll(() {
      tEndpoint = '/login-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";
      password = "password";
    });
    test('should return AuthModel on success login', () async {
      final result = await performLogin(
          url, email, password, fcmToken, authSuccessResponse());
      authSuccessExpection(result);
    });
    test('should failed if invalid response received', () async {
      final result = await performLogin(
          url, email, password, fcmToken, authInvalidResponse());
      authInvalidResponseExpection(result);
    });
    test('should failed if credentials are invalid', () async {
      final result = await performLogin(
          url,
          email,
          password,
          fcmToken,
          failureResponse(
            code: 403,
            message: "invalid credentials",
          ));
      authFailureResponseExpection(result, "invalid credentials");
    });
  });

  group('create-user', () {
    late String email;
    late String password;
    setUpAll(() {
      tEndpoint = '/create-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";
      password = "password";
      fcmToken = "fcmToken";
      tToken = "token";
    });
    test('should return AuthModel on success login', () async {
      final result = await performUserCreation(
          url, email, password, fcmToken, authSuccessResponse());
      authSuccessExpection(result);
    });

    test('should failed if invalid response received', () async {
      final result = await performUserCreation(
          url, email, password, fcmToken, authInvalidResponse());
      authInvalidResponseExpection(result);
    });
    test('should failed if account are already exists', () async {
      final result = await performUserCreation(url, email, password, fcmToken,
          failureResponse(code: 403, message: "user exist already"));
      authFailureResponseExpection(result, "user exist already");
    });
  });
  group('anonymous-login', () {
    setUpAll(() {
      tEndpoint = '/create-ano-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      mockStorageWriteToken(tToken);
    });
    test('should return AuthModel on success login', () async {
      final result =
          await performAnonLogin(url, fcmToken, authSuccessResponse());
      authSuccessExpection(result);
    });
    test('should return AuthModel on success login without fcm token',
        () async {
      final result = await performAnonLogin(url, null, authSuccessResponse());
      authSuccessExpection(result);
    });
    test('should failed if invalid response received', () async {
      final result = await performAnonLogin(url, null, authInvalidResponse());
      authInvalidResponseExpection(result);
    });
  });
  group('social login', () {
    late String email;
    late String provider;
    late String privateProfileImage;
    setUpAll(() {
      tEndpoint = '/social-login';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";
      provider = "google";
      privateProfileImage =
          "https://xsgames.co/randomusers/assets/avatars/pixel/24.jpg";
      mockStorageWriteToken(tToken);
    });
    test('should return AuthModel on success login', () async {
      final result = await performSocialLogin(url, email, provider,
          privateProfileImage, fcmToken, authSuccessResponse());
      authSuccessExpection(result);
    });
    test('should failed if invalid response received', () async {
      final result = await performSocialLogin(url, email, provider,
          privateProfileImage, fcmToken, authInvalidResponse());
      authInvalidResponseExpection(result);
    });
    test('should failed if provider is not provided', () async {
      final result = await performSocialLogin(
          url,
          email,
          "",
          null,
          fcmToken,
          failureResponse(
              code: 500,
              message:
                  "SocialLoginRequestType.Provider' Error:Field validation for 'Provider' failed on the 'required' tag"));
      authFailureResponseExpection(result,
          "SocialLoginRequestType.Provider' Error:Field validation for 'Provider' failed on the 'required' tag");
    });
    test('should failed if provider is not different', () async {
      final result = await performSocialLogin(
          url,
          email,
          "facebook",
          privateProfileImage,
          fcmToken,
          failureResponse(
              code: 400, message: "not authenticated to requesting this"));
      authFailureResponseExpection(
          result, "not authenticated to requesting this");
    });
  });
  Future<Failure?> performLogout(String? tToken, Response response) async {
    if (tToken != null) {
      Map<String, String> headers = {'content-type': 'application/json'};
      headers['authorization'] = "Bearer $tToken";
      mockPostResponse({}, response, headers: headers);
    } else {
      mockPostResponse({}, response);
    }
    return await authRepo.logout();
  }

  Future<Failure?> performAccountDeletion(
      String? tToken, Response response) async {
    if (tToken != null) {
      Map<String, String> headers = {'content-type': 'application/json'};
      headers['authorization'] = "Bearer ${null}";
      mockGetResponse(response, headers: headers);
    } else {
      mockGetResponse(response);
    }

    return await authRepo.deleteUser();
  }

  Future<(Failure?, UserModel?)> fetchUser(
      String? tToken, Response response) async {
    if (tToken != null) {
      Map<String, String> headers = {'content-type': 'application/json'};
      headers['authorization'] = "Bearer ${null}";
      mockGetResponse(response, headers: headers);
    } else {
      mockGetResponse(response);
    }

    return await authRepo.getUser();
  }

  group('logout', () {
    setUpAll(() {
      tEndpoint = '/logout';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      mockStorageReadToken();
      mockStorageDeleteToken();
    });

    test('should return failure message if token is invalid', () async {
      final result = await performLogout(
          tToken, failureResponse(code: 401, message: "invalid token"));
      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals("invalid token"));
    });

    test('should return failure message if token is expired', () async {
      final result = await performLogout(
          tToken, failureResponse(code: 401, message: "token is expired"));
      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals("token is expired"));
    });
    test('should return failure message if token is missing', () async {
      final result = await performLogout(tToken,
          failureResponse(code: 401, message: "missing authorization token"));
      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals("missing authorization token"));
    });
    test('should return success message on successfully logout', () async {
      final result = await performLogout(tToken, successResponse(data: {}));
      expect(result, isNull);
      expect(authRepo.user, equals(null));
      expect(authRepo.accessToken, equals(null));
    });
  });
  group('delete-user', () {
    setUpAll(() {
      tEndpoint = '/delete-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      mockStorageReadToken();
      mockStorageDeleteToken();
    });

    test('should return failure message if token is invalid', () async {
      final result = await performAccountDeletion(
          tToken, failureResponse(code: 401, message: "invalid token"));
      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals("invalid token"));
    });
    test('should return failure message if token is expired', () async {
      final result = await performAccountDeletion(
          tToken, failureResponse(code: 401, message: "token is expired"));
      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals("token is expired"));
    });

    test('should return success message on successfully delete', () async {
      final result =
          await performAccountDeletion(tToken, successResponse(data: {}));
      expect(result, isNull);
      expect(authRepo.user, equals(null));
      expect(authRepo.accessToken, equals(null));
    });
    test('should return failure message if token is missing', () async {
      final result = await performAccountDeletion(tToken,
          failureResponse(code: 401, message: "missing authorization token"));
      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals("missing authorization token"));
    });
  });
  group('get-user', () {
    setUpAll(() {
      tEndpoint = '/get-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      mockStorageReadToken();
    });

    test('should return failure message if token is invalid', () async {
      final result = await fetchUser(
          tToken, failureResponse(code: 401, message: "invalid token"));
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals("invalid token"));
      expect(result.$2, isNull);
    });
    test('should return failure message if token is expired', () async {
      final result = await fetchUser(
          tToken, failureResponse(code: 401, message: "token is expired"));
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals("token is expired"));
      expect(result.$2, isNull);
    });
    test('should return failure message if token is missing', () async {
      final result = await fetchUser(tToken,
          failureResponse(code: 401, message: "missing authorization token"));
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals("missing authorization token"));
      expect(result.$2, isNull);
    });
    test('should return UserModel message on successfully fetch user',
        () async {
      final result = await fetchUser(
          tToken, successResponse(data: authValidJson()['user']));
      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2, isA<UserModel>());
      expect(authRepo.user!.props, equals(result.$2!.props));
    });
    test(
        'should return failure message on successfully fetch user but invalid response',
        () async {
      final result = await fetchUser(
          tToken, successResponse(data: authInvalidJson()['user']));
      expect(result.$1, isNotNull);
      expect(result.$2, isNull);
      expect(result.$1, isA<JsonDecodeFailure>());
    });
  });
  Future<Failure?> performPasswordReset(
      String? email, Response response) async {
    Map<String, String> tBody = {};
    if (email != null) {
      tBody['email'] = email;
    }
    mockPostResponse(tBody, response);
    return await authRepo.resetPassword(email);
  }

  group('password reset', () {
    late String email;
    setUpAll(() {
      tEndpoint = '/request-password-reset';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";
    });
    test('should return success message on success password reset request ',
        () async {
      final result = await performPasswordReset(email, successResponse());
      expect(result, isNull);
    });
    test('should return failed message if email is not not provided', () async {
      final result = await performPasswordReset(
          null,
          failureResponse(
              code: 500,
              message:
                  "Key: 'PasswordResetRequest.Email' Error:Field validation for 'Email' failed on the 'required' tag"));
      expect(result, isNotNull);
      expect(
          result!.message,
          equals(
              "Key: 'PasswordResetRequest.Email' Error:Field validation for 'Email' failed on the 'required' tag"));
    });
    test('should return failed message if user is not exist', () async {
      final result = await performPasswordReset(
          email, failureResponse(code: 404, message: "user not exist"));
      expect(result, isNotNull);
      expect(result!.message, equals("user not exist"));
    });
    test(
        'should return failed message if email is either non-password based or anonymous account',
        () async {
      final result = await performPasswordReset(
          email,
          failureResponse(
              code: 400, message: "not authenticated to requesting this"));
      expect(result, isNotNull);
      expect(result!.message, equals("not authenticated to requesting this"));
    });
  });
}

//Success json Response
Response authSuccessResponse() {
  return successResponse(data: authValidJson());
}

//Invalid json Response
Response authInvalidResponse() {
  return successResponse(data: authInvalidJson());
}

Map<String, dynamic> authInvalidJson() {
  var userJson = {
    "id": "1",
    "username": "test@example.com",
    "email": "test@example.com",
    "created_at": "2023-08-22T13:41:29.914846Z",
    "updated_at": "2023-09-19T12:25:08.183553Z",
    "public_profile_image":
        "https://xsgames.co/randomusers/assets/avatars/pixel/42.jpg",
    "private_profile_image":
        "https://xsgames.co/randomusers/assets/avatars/pixel/24.jpg"
  };
  var authJson = {"token": "token", "user": userJson};
  return authJson;
}

Map<String, dynamic> authValidJson() {
  var userJson = {
    "id": 1,
    "username": "test@example.com",
    "email": "test@example.com",
    "created_at": "2023-08-22T13:41:29.914846Z",
    "updated_at": "2023-09-19T12:25:08.183553Z",
    "public_profile_image":
        "https://xsgames.co/randomusers/assets/avatars/pixel/42.jpg",
    "private_profile_image":
        "https://xsgames.co/randomusers/assets/avatars/pixel/24.jpg"
  };
  var authJson = {"token": "token", "user": userJson};
  return authJson;
}
