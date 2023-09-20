import 'package:invisquery/Features/Auth/Data/Models/user_model.dart';

class AuthModel {
  final String accessToken;
  final UserModel user;

  const AuthModel({required this.accessToken, required this.user});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        accessToken: json['access_token'],
        user: UserModel.fromJson(json['user']));
  }
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user': user.toJson(),
    };
  }
}
