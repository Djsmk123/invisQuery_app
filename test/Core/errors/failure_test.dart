import 'package:flutter_test/flutter_test.dart';
import 'package:invisquery/Core/Errors/failure.dart';

void main() {
  group('Failure classes', () {
    test('InternetConnectionFailure should have the correct message', () {
      const failure = InternetConnectionFailure();
      expect(failure.message, "Internet connection is not available");
    });

    test('EndpointFailure should have the correct message', () {
      const failure = EndpointFailure();
      expect(failure.message, "Something went wrong");
    });

    test('JsonDecodeFailure should have the correct message', () {
      const failure = JsonDecodeFailure();
      expect(failure.message, "Failed to decode data from server");
    });

    test('JsonEncodeFailure should have the correct message', () {
      const failure = JsonEncodeFailure();
      expect(failure.message, "Failed to encode data");
    });

    test('Failures should be equatable', () {
      const failure1 = InternetConnectionFailure();
      const failure2 = InternetConnectionFailure();
      const failure3 = EndpointFailure();

      // Failures with the same type and message should be equal
      expect(failure1, equals(failure2));

      // Failures with different types or messages should not be equal
      expect(failure1, isNot(equals(failure3)));
    });

    test('Failures should have the correct props', () {
      const failure1 = InternetConnectionFailure();
      const failure2 = JsonDecodeFailure();

      // Failures should have empty props lists
      expect(failure1.props, isEmpty);
      expect(failure2.props, isEmpty);
    });
  });
}
