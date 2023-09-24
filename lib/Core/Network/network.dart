import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Model/network_response.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:invisquery/Core/utils/parser.dart';

/// An abstract class defining methods for network-related operations.
abstract class NetworkService {
  /// A future that returns `true` if the device is connected to the internet, and `false` otherwise.
  Future<bool> get isConnected;

  /// A method for making GET requests to a remote endpoint.
  /// Returns a tuple of [Failure?, ApiResponseModel?].
  Future<(Failure?, ApiResponseModel?)> get(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, String>? query});

  /// A method for making POST requests to a remote endpoint.
  /// Returns a tuple of [Failure?, ApiResponseModel?].
  Future<(Failure?, ApiResponseModel?)> post(
      {required String endpoint,
      Map<String, String>? headers,
      required Map<String, dynamic> data});
}

/// An implementation of the [NetworkService] class.
class NetworkServiceImpl extends NetworkService with Parser {
  final InternetConnectionCheckerPlus connectionChecker;
  final APIInfo apiInfo;
  http.Client client;

  /// Constructor for [NetworkServiceImpl].
  NetworkServiceImpl(this.connectionChecker, this.apiInfo, this.client);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Future<(Failure?, ApiResponseModel?)> get(
      {required String endpoint,
      Map<String, String>? headers,
      Map<String, String>? query}) async {
    if (await isConnected) {
      headers ??= apiInfo.defaultHeader;
      var uri = Uri.parse(buildUrl(endpoint));
      if (query != null) {
        uri = uri.replace(queryParameters: query);
      }

      final response = await client.get(uri, headers: headers);
      return processResponse(response);
    }
    return (const InternetConnectionFailure(), null);
  }

  @override
  Future<(Failure?, ApiResponseModel?)> post(
      {required String endpoint,
      Map<String, String>? headers,
      required Map<String, dynamic> data}) async {
    if (await isConnected) {
      headers ??= apiInfo.defaultHeader;
      var uri = Uri.parse(buildUrl(endpoint));

      final encodedData = jsonToString(data);
      if (encodedData.$1 != null) {
        return (const JsonEncodeFailure(), null);
      }

      final response = await client.post(uri, headers: headers, body: data);

      return processResponse(response);
    }
    return (const InternetConnectionFailure(), null);
  }

  (Failure?, ApiResponseModel?) processResponse(http.Response response) {
    final decodedResponse = stringToJson(response.body.toString());
    if (decodedResponse.$1 == null) {
      final ApiResponseModel model =
          ApiResponseModel.fromJson(decodedResponse.$2);
      return model.success
          ? (null, model)
          : (EndpointFailure(message: model.message), null);
    }
    return (decodedResponse.$1, null);
  }

  String buildUrl(String endpoint) =>
      apiInfo.getBaseUrl() +
      apiInfo.subBaseUrl() +
      apiInfo.apiVersion() +
      endpoint;
}
