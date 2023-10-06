import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/parser.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';
import 'package:invisquery/Features/Questions/Data/Model/question_model.dart';
import 'package:invisquery/Features/Questions/Domain/Repo/question_repo.dart';

class QuestionRepositoryImpl extends QuestionRepository {
  final NetworkServiceImpl networkService;
  final AuthRepoImpl authRepo;
  QuestionRepositoryImpl(
      {required this.networkService, required this.authRepo});
  @override
  Future<(Failure?, QuestionModel?)> createQuestion(
      {required String question}) async {
    final res = await networkService.post(
        endpoint: '/create-question',
        data: {'question': question},
        headers: await authRepo.getHeaderWithToken());

    if (res.$1 != null) {
      return (res.$1, null);
    }

    var obj = questionModelParserHelper(res.$2!.data);
    return (obj.$1 != null) ? (obj.$1, null) : (null, obj.$2);
  }

  @override
  Future<(Failure?, QuestionModel?)> deleteQuestion({required int id}) async {
    final res = await networkService.get(
        endpoint: '/delete-question/$id',
        headers: await authRepo.getHeaderWithToken());
    if (res.$1 != null) {
      return (res.$1, null);
    }
    var obj = questionModelParserHelper(res.$2!.data);
    return (obj.$1 != null) ? (obj.$1, null) : (null, obj.$2);
  }

  @override
  Future<(Failure?, QuestionModel?)> getQuestion({required int id}) async {
    final res = await networkService.get(
        endpoint: '/question/$id',
        headers: await authRepo.getHeaderWithToken());
    if (res.$1 != null) {
      return (res.$1, null);
    }
    var obj = questionModelParserHelper(res.$2!.data);
    return (obj.$1 != null) ? (obj.$1, null) : (null, obj.$2);
  }

  @override
  Future<(Failure?, List<QuestionModel>)> getQuestions(
      {int pageId = 1, int pageSize = 10, String? search}) async {
    List<QuestionModel> questions = [];
    Map<String, String> query = {
      'page_id': pageId.toString(),
      'page_size': pageSize.toString()
    };
    if (search != null) {
      query['search'] = search;
    }
    final res = await networkService.get(
        endpoint: 'questions',
        query: query,
        headers: await authRepo.getHeaderWithToken());
    if (res.$1 != null) {
      return (res.$1, questions);
    }
    if (res.$2!.data! is List<dynamic>) {
      return (
        const EndpointFailure(message: "Invalid response from server"),
        questions
      );
    }
    List<dynamic> data = res.$2!.data;
    for (final item in data) {
      var obj = questionModelParserHelper(item);
      if (obj.$1 == null && obj.$2 != null) {
        questions.add(obj.$2!);
      }
    }
    return (null, questions);
  }

  @override
  Future<(Failure?, QuestionModel?)> updateQuestion(
      {required int id, required String content}) async {
    final res = await networkService.post(
        endpoint: '/update-question',
        headers: await authRepo.getHeaderWithToken(),
        data: {
          'question': content,
          'id': id,
        });
    if (res.$1 != null) {
      return (res.$1, null);
    }
    var obj = questionModelParserHelper(res.$2!.data);
    return (obj.$1 != null) ? (obj.$1, null) : (null, obj.$2);
  }

  (Failure?, QuestionModel?) questionModelParserHelper(dynamic data) {
    JsonObjectUtils<QuestionModel> utils = JsonObjectUtils<QuestionModel>();
    final obj = utils.jsonToObject(() => QuestionModel.fromJson(data));
    return (obj);
  }
}
