import 'package:flutter_test/flutter_test.dart';
import 'package:invisquery/Core/Model/network_response.dart';

void main() {
  group('ApiResponseModel', () {
    test('fromJson - valid JSON', () {
      // Create a sample JSON object
      final json = {
        'status_code': 200,
        'message': 'Success',
        'data': {'name': 'John Doe', 'age': 25},
        'success': true,
      };

      // Call the fromJson method
      final model = ApiResponseModel.fromJson(json);

      // Assertions
      expect(model.statusCode, 200);
      expect(model.message, 'Success');
      expect(model.data, {'name': 'John Doe', 'age': 25});
      expect(model.success, true);
    });

    test('fromJson - missing fields', () {
      // Create a sample JSON object with missing fields
      final json = {
        'status_code': 200,
        'message': 'Success',
        // 'data' field is missing
        'success': true,
      };

      // Call the fromJson method
      final model = ApiResponseModel.fromJson(json);

      // Assertions
      expect(model.statusCode, 200);
      expect(model.message, 'Success');
      expect(model.data, isNull);
      expect(model.success, true);
    });

    test('toJson', () {
      // Create a sample ApiResponseModel instance
      const model =
          ApiResponseModel(200, 'Success', {'name': 'John Doe'}, true);

      // Call the toJson method
      final json = model.toJson();

      // Assertions
      expect(json['status_code'], 200);
      expect(json['message'], 'Success');
      expect(json['data'], {'name': 'John Doe'});
      expect(json['success'], true);
    });

    test('props', () {
      // Create two ApiResponseModel instances with the same values
      const model1 =
          ApiResponseModel(200, 'Success', {'name': 'John Doe'}, true);
      const model2 =
          ApiResponseModel(200, 'Success', {'name': 'John Doe'}, true);

      // Assertions
      expect(model1.props, model2.props);
    });
  });
}
