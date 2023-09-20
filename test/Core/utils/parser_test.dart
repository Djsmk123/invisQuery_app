import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/utils/parser.dart';

class JsonParser with Parser {}

void main() {
  group('Parser mixin', () {
    late JsonParser parser;

    setUp(() {
      parser = JsonParser();
    });

    test('stringToJson should decode valid JSON', () {
      // Arrange
      const jsonString =
          '{"status_code": 200, "message": "Success fully authenticated", "data": [], "success": "true"}';

      // Act
      final result = parser.stringToJson(jsonString);

      // Assert
      expect(
          result.$1, isNull); // Failure should be null for a successful decode.
      expect(result.$2, isA<Map<String, dynamic>>());
      expect(result.$2['success'], 'true');
    });

    test('stringToJson should handle invalid JSON', () {
      // Arrange
      const jsonString = 'invalid_json';

      // Act
      final result = parser.stringToJson(jsonString);

      // Assert
      expect(result.$1, isA<JsonDecodeFailure>());
      expect(result.$2,
          isA<Map<String, dynamic>>()); // It should return an empty map.
      expect(result.$2, isEmpty);
    });

    test('jsonToString should encode valid JSON', () {
      // Arrange
      final jsonMap = {'key': 'value'};

      // Act
      final result = parser.jsonToString(jsonMap);

      // Assert
      expect(
          result.$1, isNull); // Failure should be null for a successful encode.
      expect(result.$2, '{"key":"value"}');
    });

    test('jsonToString should handle encoding errors', () {
      // Arrange
      final invalidJsonMap = {
        'key': const Scaffold()
      }; // A function cannot be encoded to JSON.

      // Act
      final result = parser.jsonToString(invalidJsonMap);

      // Assert
      expect(result.$1, isA<JsonEncodeFailure>());
      expect(result.$2, ''); // It should return an empty string.
    });
  });
}
