import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Features/Auth/Data/Models/auth_model.dart';
import 'package:invisquery/Features/Auth/Data/Models/user_model.dart';

abstract class AuthRepo {
  Future<(Failure?, AuthModel?)> login(
    final String email,
    final String password,
    String? fcmToken,
  );
  Future<(Failure?, AuthModel?)> signUp(
    final String email,
    final String password,
    String? fcmToken,
  );
  Future<(Failure?, AuthModel?)> anonymous(
    String? fcmToken,
  );
  Future<(Failure?, AuthModel?)> socialLogin(
    final String email,
    final String provider,
    final String? privateProfileImage,
    final String? fcmToken,
  );
  Future<(Failure?, UserModel?)> getUser();
  Future<Failure?> deleteUser();
  Future<Failure?> logout();
  Future<Failure?> resetPassword(final String email);
  Future<(Failure?, String?)> getAccessToken();
  abstract String? accessToken;
  abstract UserModel? user;
}
