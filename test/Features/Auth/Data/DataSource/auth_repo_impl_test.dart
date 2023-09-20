import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../Core/Network/network_test.mocks.dart';
import '../../../../Core/utils/storage_test.mocks.dart';

void main() {
  late AuthRepoImpl authRepo;
  late MockInternetConnectionCheckerPlus mockInternetConnectionChecker;
  late APIInfo apiInfo;
  late MockClient mockClient;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late NetworkServiceImpl networkServiceImpl;
  late StorageService storageService;

  setUpAll(() {
    // Initialize the AuthRepoImpl with mock dependencies or test-specific ones.
    mockInternetConnectionChecker = MockInternetConnectionCheckerPlus();
    apiInfo = APIInfo();
    mockClient = MockClient();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    networkServiceImpl =
        NetworkServiceImpl(mockInternetConnectionChecker, apiInfo, mockClient);
    storageService = StorageService(mockFlutterSecureStorage);
    authRepo = AuthRepoImpl(networkServiceImpl, storageService);
    when(mockInternetConnectionChecker.hasConnection)
        .thenAnswer((_) async => true);
  });
  group('login-user', () {
    late String tEndpoint;
    late Uri url;
    late String email;
    late String password;
    late String fcmToken;
    late String tToken;
    setUpAll(() {
      tEndpoint = '/login';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";
      password = "password";
      fcmToken = "fcmToken";
      tToken = "token";
    });
    test('should return AuthModel on success login', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken
      };
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result =
          await authRepo.login('test@example.com', 'password', fcmToken);

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2!.accessToken, equals(authJson['access_token']));
      expect(result.$2!.toJson(), equals(authJson));
      expect(result.$2!.user.toJson(), equals(userJson));
    });
    test('should failed if invalid response received', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken
      };
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result =
          await authRepo.login('test@example.com', 'password', fcmToken);

      expect(result.$1, isNotNull);
      expect(result.$2, isNull);
      expect(result.$1, isA<JsonDecodeFailure>());
    });
    test('should failed if credentials are invalid', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken
      };

      var apiResponse = {
        "status_code": 403,
        "message": "invalid credentials",
        "data": null,
        "success": false
      };
      Response response = Response(jsonEncode(apiResponse), 403);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);

      final result =
          await authRepo.login('test@example.com', 'password', fcmToken);
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals(apiResponse['message']));
    });
  });
  group('create-user', () {
    late String tEndpoint;
    late Uri url;
    late String email;
    late String password;
    late String fcmToken;
    late String tToken;
    setUpAll(() {
      tEndpoint = '/create-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";
      password = "password";
      fcmToken = "fcmToken";
      tToken = "token";
    });
    test('should return AuthModel on success login', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken
      };
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result =
          await authRepo.signUp('test@example.com', 'password', fcmToken);

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2!.accessToken, equals(authJson['access_token']));
      expect(result.$2!.toJson(), equals(authJson));
      expect(result.$2!.user.toJson(), equals(userJson));
    });
    test('should failed if invalid response received', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken
      };
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result =
          await authRepo.signUp('test@example.com', 'password', fcmToken);

      expect(result.$1, isNotNull);
      expect(result.$2, isNull);
      expect(result.$1, isA<JsonDecodeFailure>());
    });
    test('should failed if account are already exists', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken
      };

      var apiResponse = {
        "status_code": 403,
        "message": "user exist already",
        "data": null,
        "success": false
      };
      Response response = Response(jsonEncode(apiResponse), 403);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);

      final result =
          await authRepo.signUp('test@example.com', 'password', fcmToken);
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals(apiResponse['message']));
    });
  });
  group('anonymous-login', () {
    late String tEndpoint;
    late Uri url;

    late String fcmToken;
    late String tToken;
    setUpAll(() {
      tEndpoint = '/create-ano-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));

      fcmToken = "fcmToken";
      tToken = "token";
    });
    test('should return AuthModel on success login', () async {
      Map<String, dynamic> tBody = {'fcm_token': fcmToken};
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result = await authRepo.anonymous(fcmToken);

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2!.accessToken, equals(authJson['access_token']));
      expect(result.$2!.toJson(), equals(authJson));
      expect(result.$2!.user.toJson(), equals(userJson));
    });
    test('should return AuthModel on success login without fcm token',
        () async {
      Map<String, dynamic> tBody = {};
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result = await authRepo.anonymous(null);
      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2!.accessToken, equals(authJson['access_token']));
      expect(result.$2!.toJson(), equals(authJson));
      expect(result.$2!.user.toJson(), equals(userJson));
    });
    test('should failed if invalid response received', () async {
      Map<String, dynamic> tBody = {'fcm_token': fcmToken};
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
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result = await authRepo.anonymous(fcmToken);

      expect(result.$1, isNotNull);
      expect(result.$2, isNull);
      expect(result.$1, isA<JsonDecodeFailure>());
    });
  });
  group('social login', () {
    late String tEndpoint;
    late Uri url;
    late String email;

    late String fcmToken;
    late String tToken;
    late String provider;
    late String privateProfileImage;
    setUpAll(() {
      tEndpoint = '/social-login';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
      email = "test@example.com";

      fcmToken = "fcmToken";
      tToken = "token";
      provider = "google";
      privateProfileImage =
          "https://xsgames.co/randomusers/assets/avatars/pixel/24.jpg";
    });
    test('should return AuthModel on success login', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'private_profile_image': privateProfileImage,
        'provider': provider,
        'fcm_token': fcmToken,
      };
      var userJson = {
        "id": 1,
        "username": "test@example.com",
        "email": "test@example.com",
        "created_at": "2023-08-22T13:41:29.914846Z",
        "updated_at": "2023-09-19T12:25:08.183553Z",
        "public_profile_image":
            "https://xsgames.co/randomusers/assets/avatars/pixel/42.jpg",
        "private_profile_image": privateProfileImage
      };
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result = await authRepo.socialLogin(
          'test@example.com', provider, privateProfileImage, fcmToken);

      expect(result.$1, isNull);
      expect(result.$2, isNotNull);
      expect(result.$2!.accessToken, equals(authJson['access_token']));
      expect(result.$2!.toJson(), equals(authJson));
      expect(result.$2!.user.toJson(), equals(userJson));
    });
    test('should failed if invalid response received', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'private_profile_image': privateProfileImage,
        'fcm_token': fcmToken,
        'provider': provider,
      };
      var userJson = {
        "id": "1",
        "username": "test@example.com",
        "email": "test@example.com",
        "created_at": "2023-08-22T13:41:29.914846Z",
        "updated_at": "2023-09-19T12:25:08.183553Z",
        "public_profile_image":
            "https://xsgames.co/randomusers/assets/avatars/pixel/42.jpg",
        "private_profile_image": privateProfileImage,
      };
      var authJson = {"access_token": "token", "user": userJson};
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": authJson,
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);
      when(storageService.write("token", tToken))
          .thenAnswer((_) => Future.value());
      final result = await authRepo.socialLogin(
          'test@example.com', provider, privateProfileImage, fcmToken);

      expect(result.$1, isNotNull);
      expect(result.$2, isNull);
      expect(result.$1, isA<JsonDecodeFailure>());
    });
    test('should failed if provider is not provided', () async {
      Map<String, dynamic> tBody = {
        'email': email,
        'private_profile_image': null,
        'provider': '',
        'fcm_token': fcmToken
      };

      var apiResponse = {
        "status_code": 500,
        "message":
            "Key: 'SocialLoginRequestType.Provider' Error:Field validation for 'Provider' failed on the 'required' tag",
        "data": null,
        "success": false
      };
      Response response = Response(jsonEncode(apiResponse), 500);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);

      final result =
          await authRepo.socialLogin('test@example.com', '', null, fcmToken);
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals(apiResponse['message']));
    });
    test('should failed if provider is not different', () async {
      provider = "facebook";
      Map<String, dynamic> tBody = {
        'email': email,
        'fcm_token': fcmToken,
        "provider": provider,
        'private_profile_image': privateProfileImage,
      };

      var apiResponse = {
        "status_code": 400,
        "message": "not authenticated to requesting this",
        "data": null,
        "success": false
      };
      Response response = Response(jsonEncode(apiResponse), 400);
      when(mockClient.post(url,
              headers: apiInfo.defaultHeader, body: tBody, encoding: null))
          .thenAnswer((v) async => response);

      final result = await authRepo.socialLogin(
          'test@example.com', provider, privateProfileImage, fcmToken);
      expect(result.$1, isNotNull);
      expect(result.$1, isA<EndpointFailure>());
      expect(result.$1!.message, equals(apiResponse['message']));
    });
  });
  group('logout', () {
    late String tEndpoint;
    late Uri url;

    setUpAll(() {
      tEndpoint = '/logout';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
    });
    test('should return success message on successfully logout', () async {
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": "",
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.post(url, headers: apiInfo.defaultHeader, body: {}))
          .thenAnswer((v) async => response);
      when(storageService.deleteAll()).thenAnswer((_) => Future.value());
      final result = await authRepo.logout();

      expect(result, isNull);
      expect(authRepo.user, equals(null));
      expect(authRepo.accessToken, equals(null));
    });
    test('should return failure message on un-success logout', () async {
      var apiResponse = {
        "status_code": 401,
        "message": "token is expired",
        "data": null,
        "success": false,
      };
      Response response = Response(jsonEncode(apiResponse), 401);
      when(mockClient.post(url, headers: apiInfo.defaultHeader, body: {}))
          .thenAnswer((v) async => response);
      when(storageService.deleteAll()).thenAnswer((_) => Future.value());
      final result = await authRepo.logout();

      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals(apiResponse['message']));
    });
  });
  group('delete', () {
    late String tEndpoint;
    late Uri url;

    setUpAll(() {
      tEndpoint = '/delete-user';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
    });
    test('should return success message on successfully delete', () async {
      var apiResponse = {
        "status_code": 200,
        "message": "Request has been served successfully",
        "data": "",
        "success": true
      };
      Response response = Response(jsonEncode(apiResponse), 200);
      when(mockClient.get(url, headers: apiInfo.defaultHeader))
          .thenAnswer((v) async => response);
      when(storageService.deleteAll()).thenAnswer((_) => Future.value());
      final result = await authRepo.deleteUser();

      expect(result, isNull);
      expect(authRepo.user, equals(null));
      expect(authRepo.accessToken, equals(null));
    });
    test('should return failure message on un-success delete', () async {
      var apiResponse = {
        "status_code": 401,
        "message": "token is expired",
        "data": null,
        "success": false,
      };
      Response response = Response(jsonEncode(apiResponse), 401);
      when(mockClient.get(url, headers: apiInfo.defaultHeader))
          .thenAnswer((v) async => response);
      when(storageService.deleteAll()).thenAnswer((_) => Future.value());
      final result = await authRepo.deleteUser();

      expect(result, isNotNull);
      expect(result, isA<EndpointFailure>());
      expect(result!.message, equals(apiResponse['message']));
    });
  });
}
