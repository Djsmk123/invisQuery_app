import 'package:equatable/equatable.dart';

class QuestionModel extends Equatable {
  final int id;
  final int userId;
  final String content;
  final String createdAt;
  final String updatedAt;
  const QuestionModel(
      {required this.id,
      required this.userId,
      required this.content,
      required this.createdAt,
      required this.updatedAt});
  @override
  List<Object?> get props => [id, userId, content, createdAt, updatedAt];
  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
        id: json['id'],
        userId: json['user_id'],
        content: json['content'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at']);
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
