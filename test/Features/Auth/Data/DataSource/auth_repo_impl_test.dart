import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../Core/Network/network_test.mocks.dart';
import '../../../../Core/utils/storage_test.mocks.dart';

void main() {
  group('AuthRepoImpl', () {
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
      networkServiceImpl = NetworkServiceImpl(
          mockInternetConnectionChecker, apiInfo, mockClient);
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
        Response response = Response("""{
  "status_code": 200,
  "message": "Request has been served successfully",
  "data": {
    "access_token": "token",
    "user": {
      "id": 1,
      "username": "test@example.com",
      "email": "test@example.com",
      "created_at": "2023-08-22T13:41:29.914846Z",
      "updated_at": "2023-09-19T12:25:08.183553Z",
      "public_profile_image": "https://xsgames.co/randomusers/assets/avatars/pixel/42.jpg",
      "private_profile_image": "https://xsgames.co/randomusers/assets/avatars/pixel/24.jpg"
    }
  },
  "success": true
}""", 200);
        when(mockClient.post(url,
                headers: apiInfo.defaultHeader, body: tBody, encoding: null))
            .thenAnswer((v) async => response);
        when(storageService.write("token", tToken))
            .thenAnswer((_) => Future.value());
        final result =
            await authRepo.login('test@example.com', 'password', fcmToken);

        expect(result.$1, isNull);
        expect(result.$2, isNotNull);
      });
    });
    /*

    test('anonymous should return a Failure and AuthModel', () async {
      final result = await authRepo.anonymous(null);

      expect(result, isA<(Failure?, AuthModel?)>());
      expect(result.item1, isA<Failure>());
      expect(result.item2, isA<AuthModel>());
    });

    test('deleteUser should return a Failure', () async {
      final result = await authRepo.deleteUser();

      expect(result, isA<Failure>());
    });

    test('getUser should return a Failure and UserModel', () async {
      final result = await authRepo.getUser();

      expect(result, isA<Tuple2<Failure?, UserModel?>>());
      expect(result.item1, isA<Failure>());
      expect(result.item2, isA<UserModel>());
    });

    test('logout should return a Failure', () async {
      final result = await authRepo.logout();

      expect(result, isA<Failure>());
    });

    test('resetPassword should return a Failure', () async {
      final result = await authRepo.resetPassword('test@example.com');

      expect(result, isA<Failure>());
    });

    test('signUp should return a Failure and AuthModel', () async {
      final result =
          await authRepo.signUp('test@example.com', 'password', null);

      expect(result, isA<Tuple2<Failure?, AuthModel?>>());
      expect(result.item1, isA<Failure>());
      expect(result.item2, isA<AuthModel>());
    });

    test('socialLogin should return a Failure and AuthModel', () async {
      final result = await authRepo.socialLogin(
        'test@example.com',
        'provider',
        null,
        null,
      );

      expect(result, isA<Tuple2<Failure?, AuthModel?>>());
      expect(result.item1, isA<Failure>());
      expect(result.item2, isA<AuthModel>());
    });

    test('getAccessToken should return a Failure and String', () async {
      final result = await authRepo.getAccessToken();

      expect(result, isA<Tuple2<Failure?, String?>>());
      expect(result.item1, isA<Failure>());
      expect(result.item2, isA<String>());
    });*/
  });
}
