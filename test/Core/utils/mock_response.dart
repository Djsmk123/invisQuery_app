import 'dart:convert';

import 'package:http/http.dart';
import 'package:invisquery/Core/Model/network_response.dart';

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
