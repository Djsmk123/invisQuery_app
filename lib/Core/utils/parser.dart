import 'dart:convert';
import 'dart:developer';

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

class JsonObjectUtils<T> {
  (Failure?, T?) jsonToObject(T Function() convert) {
    try {
      return (null, convert());
    } catch (e) {
      log(e.toString(), name: "jsonDecodeError");
    }
    return (const JsonDecodeFailure(), null);
  }
}
