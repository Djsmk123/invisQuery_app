import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Features/Questions/Data/Model/question_model.dart';

abstract class QuestionRepository {
  Future<(Failure?, List<QuestionModel>)> getQuestions(
      {int pageId = 1, int pageSize = 10, String? search});
  Future<(Failure?, QuestionModel?)> getQuestion({required int id});
  Future<(Failure?, QuestionModel?)> updateQuestion(
      {required int id, required String content});
  Future<(Failure?, QuestionModel?)> deleteQuestion({required int id});
  Future<(Failure?, QuestionModel?)> createQuestion({required String question});
}
