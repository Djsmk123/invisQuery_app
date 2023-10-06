import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Model/network_response.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:mockito/mockito.dart';

import '../Network/network_test.mocks.dart';

var errTokenExpired = "token is expired";
var errInvalidToken = "invalid authorization header";
var errMissingToken = "missing authorization header";
Response tokenResponse(String err) {
  return Response(
      jsonEncode(ApiResponseModel(statusCode: 401, message: err, success: false)
          .toJson()),
      401);
}

tokenTestCase(Failure failure, String message) {
  expect(failure, isA<EndpointFailure>());
  expect(failure.message, equals(message));
}

Response failureResponse({
  String? message,
  int code = 404,
}) {
  return Response(
      jsonEncode(ApiResponseModel(
              statusCode: code,
              message: message ?? "Some thing is wrong",
              data: null,
              success: false)
          .toJson()),
      code);
}

Response successResponse({
  String message = "Request has been served successfully",
  int code = 200,
  dynamic data,
}) {
  return Response(
      jsonEncode(ApiResponseModel(
              statusCode: code, message: message, data: data, success: true)
          .toJson()),
      code);
}

class MockApiResponseHelper {
  final MockHttpWithMiddleware mockClient;
  final APIInfo apiInfo;

  MockApiResponseHelper({required this.mockClient, required this.apiInfo});
  void mockPostResponse(Map<String, dynamic> tBody, Response response,
      {Map<String, String>? headers, required Uri url}) {
    when(mockClient.post(
      url,
      headers: headers ?? apiInfo.defaultHeader,
      body: jsonEncode(tBody),
    )).thenAnswer((v) async => response);
  }

  void mockGetResponse(Response response,
      {Map<String, String>? headers,
      Map<String, String>? query,
      required Uri url}) {
    if (query != null) {
      url = url.replace(queryParameters: query);
    }
    when(mockClient.get(
      url,
      headers: headers ?? apiInfo.defaultHeader,
    )).thenAnswer((v) async => response);
  }
}
