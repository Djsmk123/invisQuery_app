import 'package:logger/logger.dart' as l;
import 'package:pretty_http_logger/pretty_http_logger.dart';

class HttpLogger extends MiddlewareContract {
  final l.Logger logger;

  HttpLogger(this.logger);
  @override
  void interceptRequest(RequestData data) {
    logger.d("Method: ${data.method.name}");
    logger.d("Url: ${data.url.toString()}");
    logger.d("Headers ${data.headers.toString()}");
    logger.d("Body: ${data.body.toString()}");
  }

  @override
  void interceptResponse(ResponseData data) {
    logger.i("Status Code: ${data.statusCode}");
    logger.i("Method: ${data.method}");
    logger.i("Url: ${data.url}");
    logger.i("Body: ${data.body}");
    logger.i("Headers: ${data.headers}");
  }

  @override
  void interceptError(error) {
    logger.e("Error: $error");
  }
}
