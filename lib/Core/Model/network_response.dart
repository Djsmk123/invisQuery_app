import 'package:equatable/equatable.dart';

class ApiResponseModel extends Equatable {
  final int statusCode;
  final String message;
  final dynamic data;
  final bool success;

  const ApiResponseModel(
      this.statusCode, this.message, this.data, this.success);

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      json['status_code'],
      json['message'],
      json['data'],
      json['success'],
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
