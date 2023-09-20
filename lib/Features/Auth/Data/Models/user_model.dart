import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String username;
  final String email;
  final String publicProfileImage;
  final String privateProfileImage;
  final String createdAt;
  final String updatedAt;

  const UserModel(
      {required this.id,
      required this.username,
      required this.email,
      required this.publicProfileImage,
      required this.privateProfileImage,
      required this.createdAt,
      required this.updatedAt});

  @override
  List<Object?> get props => [
        id,
        username,
        publicProfileImage,
        email,
        privateProfileImage,
        createdAt,
        updatedAt
      ];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        publicProfileImage: json['public_profile_image'],
        privateProfileImage: json['private_profile_image'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'public_profile_image': publicProfileImage,
      'private_profile_image': privateProfileImage,
      'created_at': createdAt,
      'updated_at': updatedAt
    };
  }
}
