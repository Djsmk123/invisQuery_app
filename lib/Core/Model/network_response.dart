import 'package:equatable/equatable.dart';

class ApiResponseModel extends Equatable {
  final int statusCode;
  final String message;
  final dynamic data;
  final bool success;

  const ApiResponseModel(
      {required this.statusCode,
      required this.message,
      this.data,
      required this.success});

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'],
      success: json['success'],
    );
  }

  @override
  List<Object?> get props => [statusCode, message, data, success];

  Map<String, dynamic> toJson() {
    return {
      'status_code': statusCode,
      'message': message,
      'data': data,
      'success': success
    };
  }
}
