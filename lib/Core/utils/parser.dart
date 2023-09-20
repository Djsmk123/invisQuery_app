import 'dart:convert';

import 'package:invisquery/Core/Errors/failure.dart';

mixin Parser<t> {
  (Failure?, Map<String, dynamic>) stringToJson(String value) {
    try {
      final decode = jsonDecode(value);
      return (null, decode);
    } catch (e) {
      return (const JsonDecodeFailure(), {});
    }
  }

  (Failure?, String value) jsonToString(Map<String, dynamic> json) {
    try {
      final encode = jsonEncode(json);
      return (null, encode);
    } catch (e) {
      return (const JsonEncodeFailure(), "");
    }
  }
}

class JsonObjectUtils<t> {
  (Failure?, t?) jsonToObject(t Function() convert) {
    try {
      t res = convert();
      return (null, res);
    } catch (e) {
      return (const JsonDecodeFailure(), null);
    }
  }
}
