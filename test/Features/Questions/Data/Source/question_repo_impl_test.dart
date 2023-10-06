import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:invisquery/Features/Questions/Data/Model/question_model.dart';
import 'package:invisquery/Features/Questions/Data/Source/question_repo_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../Core/Network/network_test.mocks.dart';
import '../../../../Core/utils/mock_response.dart';
import '../../../../Core/utils/storage_test.mocks.dart';

void main() {
  late AuthRepoImpl authRepo;
  late MockInternetConnection mockInternetConnectionChecker;
  late APIInfo apiInfo;
  late MockHttpWithMiddleware mockClient;
  late MockFlutterSecureStorage mockFlutterSecureStorage;
  late NetworkServiceImpl networkServiceImpl;
  late StorageService storageService;
  late String tEndpoint;
  late String tToken;
  late Uri url;
  late QuestionRepositoryImpl questionRepo;
  late MockApiResponseHelper apiResponseHelper;

  void mockToken(String? token) {
    when(mockFlutterSecureStorage.read(key: "token"))
        .thenAnswer((_) => Future.value(token));
  }

  setUpAll(() {
    tToken = "token";
    // Initialize the AuthRepoImpl with mock dependencies or test-specific ones.
    mockInternetConnectionChecker = MockInternetConnection();
    apiInfo = APIInfo();
    mockClient = MockHttpWithMiddleware();
    mockFlutterSecureStorage = MockFlutterSecureStorage();
    networkServiceImpl =
        NetworkServiceImpl(mockInternetConnectionChecker, mockClient);
    storageService = StorageService(mockFlutterSecureStorage);
    authRepo = AuthRepoImpl(networkServiceImpl, storageService);
    questionRepo = QuestionRepositoryImpl(
        networkService: networkServiceImpl, authRepo: authRepo);

    apiResponseHelper =
        MockApiResponseHelper(mockClient: mockClient, apiInfo: apiInfo);
    when(mockInternetConnectionChecker.hasInternetAccess)
        .thenAnswer((_) async => true);
  });
  Future<(Failure?, QuestionModel?)> performQuestionCreation(
      {required dynamic question,
      String? token,
      required Response response}) async {
    Map<String, String> headers = {'content-type': 'application/json'};
    headers['authorization'] = 'Bearer $token';
    mockToken(tToken);

    apiResponseHelper.mockPostResponse(
        {'question': question.toString()}, response,
        url: url, headers: headers);
    return await questionRepo.createQuestion(question: question.toString());
  }

  Future<(Failure?, QuestionModel?)> fetchQuestion(
      {required int id, String? token, required Response response}) async {
    Map<String, String> headers = {'content-type': 'application/json'};
    headers['authorization'] = 'Bearer $token';
    url = url.replace(path: '/$id');
    mockToken(tToken);
    apiResponseHelper.mockGetResponse(response, url: url, headers: headers);
    return await questionRepo.getQuestion(id: id);
  }

  group('create-question', () {
    late String tContent;
    setUpAll(() {
      tContent = "who tf am I?";
      tEndpoint = '/create-question';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
    });
    //Possible test cases successfully
    // 1). Question Created successfully without any error
    // 2). Question created successfully but invalid response received
    test('should return question with correct response', () async {
      final res = await performQuestionCreation(
          question: tContent, response: validQuestionResponse(), token: tToken);
      expect(res.$1, isNull);
      expect(res.$2, isNotNull);
      expect(res.$2, isA<QuestionModel>());
      expect(res.$2!.id, equals(questionValidJson()['id']));
      expect(res.$2!.content, equals(questionValidJson()['content']));
      expect(res.$2!.userId, equals(questionValidJson()['user_id']));
      expect(res.$2!.createdAt, equals(questionValidJson()['created_at']));
      expect(res.$2!.updatedAt, equals(questionValidJson()['updated_at']));
      expect(res.$2!.props,
          equals(QuestionModel.fromJson(questionValidJson()).props));
    });
    test('should return failure causing incorrect response', () async {
      final res = await performQuestionCreation(
          question: tContent,
          response: invalidQuestionResponse(),
          token: tToken);
      expect(res.$1, isNotNull);
      expect(res.$2, isNull);
      expect(res.$1, isA<JsonDecodeFailure>());
      expect(res.$1!.message, equals(const JsonDecodeFailure().message));
    });

    //Possible test cases for failed responses
    // 1). Invalid auth token
    test('should return failure if auth token is invalid', () async {
      final res = await performQuestionCreation(
          question: tContent,
          response: tokenResponse(errInvalidToken),
          token: tToken);

      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      tokenTestCase(res.$1!, errInvalidToken);
    });
    test('should return failure if auth token is expired', () async {
      final res = await performQuestionCreation(
          question: tContent,
          response: tokenResponse(errTokenExpired),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      tokenTestCase(res.$1!, errTokenExpired);
    });
    test('should return failure if auth token is missing', () async {
      final res = await performQuestionCreation(
          question: tContent,
          response: tokenResponse(errMissingToken),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      tokenTestCase(res.$1!, errMissingToken);
    });
    // 2). Invalid response sent by client
    test('should return failure if invalid response sent to server', () async {
      final res = await performQuestionCreation(
          question: 1,
          response: failureResponse(
            code: 500,
            message:
                "json: cannot unmarshal number into Go struct field CreateQuestionRequest.question of type string",
          ),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      expect(res.$1!.message,
          "json: cannot unmarshal number into Go struct field CreateQuestionRequest.question of type string");
    });
    test('should return failure if invalid response is not sent to server',
        () async {
      final res = await performQuestionCreation(
          question: 1,
          response: failureResponse(
            code: 500,
            message:
                "Key: 'CreateQuestionRequest.Question' Error:Field validation for 'Question' failed on the 'required' tag",
          ),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      expect(res.$1!.message,
          "Key: 'CreateQuestionRequest.Question' Error:Field validation for 'Question' failed on the 'required' tag");
    });
  });
  group('get-question', () {
    late int tQuestionId;
    setUpAll(() {
      tQuestionId = 1;
      tEndpoint = '/question';
      url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
    });
    //Possible test cases successfully
    // 1). Question Created successfully without any error
    // 2). Question created successfully but invalid response received
    test('should return question with correct response', () async {
      final res = await fetchQuestion(
          id: tQuestionId, response: validQuestionResponse(), token: tToken);
      expect(res.$1, isNull);
      expect(res.$2, isNotNull);
      expect(res.$2, isA<QuestionModel>());
      expect(res.$2!.id, equals(questionValidJson()['id']));
      expect(res.$2!.content, equals(questionValidJson()['content']));
      expect(res.$2!.userId, equals(questionValidJson()['user_id']));
      expect(res.$2!.createdAt, equals(questionValidJson()['created_at']));
      expect(res.$2!.updatedAt, equals(questionValidJson()['updated_at']));
      expect(res.$2!.props,
          equals(QuestionModel.fromJson(questionValidJson()).props));
    });
    test('should return failure causing incorrect response', () async {
      final res = await fetchQuestion(
          id: tQuestionId, response: invalidQuestionResponse(), token: tToken);
      expect(res.$1, isNotNull);
      expect(res.$2, isNull);
      expect(res.$1, isA<JsonDecodeFailure>());
      expect(res.$1!.message, equals(const JsonDecodeFailure().message));
    });

    //Possible test cases for failed responses
    // 1). Invalid auth token
    test('should return failure if auth token is invalid', () async {
      final res = await fetchQuestion(
          id: tQuestionId,
          response: tokenResponse(errInvalidToken),
          token: tToken);

      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      tokenTestCase(res.$1!, errInvalidToken);
    });
    test('should return failure if auth token is expired', () async {
      final res = await fetchQuestion(
          id: tQuestionId,
          response: tokenResponse(errTokenExpired),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      tokenTestCase(res.$1!, errTokenExpired);
    });
    test('should return failure if auth token is missing', () async {
      final res = await fetchQuestion(
          id: tQuestionId,
          response: tokenResponse(errMissingToken),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      tokenTestCase(res.$1!, errMissingToken);
    });
    //2). question not found
    test('should return failure if auth token is missing', () async {
      final res = await fetchQuestion(
          id: tQuestionId,
          response: failureResponse(code: 404, message: "question not found"),
          token: tToken);
      expect(res.$2, isNull);
      expect(res.$1, isNotNull);
      expect(res.$1!.message, equals('question not found'));
    });
  });
}

//Success json Response
Response validQuestionResponse() {
  return successResponse(data: questionValidJson());
}

//Invalid json Response
Response invalidQuestionResponse() {
  return successResponse(data: questionInvalidJson());
}

Map<String, dynamic> questionInvalidJson() {
  var question = {
    'id': '1',
    'user_id': "2",
    "content": "who tf am I?",
    'created_at': '2023-10-06T09:06:23.018268Z',
    'updated_at': '2023-10-06T09:06:23.018268Z',
  };

  return question;
}

Map<String, dynamic> questionValidJson() {
  var question = {
    'id': 1,
    'user_id': 1,
    "content": "who tf am I?",
    'created_at': '2023-10-06T09:06:23.018268Z',
    'updated_at': '2023-10-06T09:06:23.018268Z',
  };
  return question;
}
