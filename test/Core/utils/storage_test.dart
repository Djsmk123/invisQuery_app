import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:invisquery/Core/Errors/failure.dart'; // Import your failure classes here
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'storage_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  group('StorageService', () {
    late MockFlutterSecureStorage mockStorage;
    late StorageService storageService;

    setUpAll(() {
      mockStorage = MockFlutterSecureStorage();

      storageService = StorageService(mockStorage);
    });

    test('readStorage with key found should return value', () async {
      const key = 'testKey';
      const value = 'testValue';

      when(mockStorage.read(key: key)).thenAnswer((_) => Future.value(value));

      final result = await storageService.readStorage(key);

      expect(result, equals((null, value)));
    });

    test('readStorage with key not found should return StorageFailure',
        () async {
      const key = 'testKey';

      when(mockStorage.read(key: key)).thenAnswer((_) => Future.value(null));

      final result = await storageService.readStorage(key);

      expect(
        result,
        equals((const StorageFailure(message: "Required key not found"), null)),
      );
    });

    test('readStorage with an error should return StorageFailure', () async {
      const key = 'testKey';

      when(mockStorage.read(key: key)).thenThrow(Exception('Test error'));

      final result = await storageService.readStorage(key);

      expect(result, equals((const StorageFailure(), null)));
    });

    test('write should return null on success', () async {
      const key = 'testKey';
      const value = 'testValue';

      when(mockStorage.write(key: key, value: value))
          .thenAnswer((_) => Future.value());

      final result = await storageService.write(key, value);

      expect(result, isNull);
    });

    test('write should return StorageFailure on error', () async {
      const key = 'testKey';
      const value = 'testValue';

      when(mockStorage.write(key: key, value: value))
          .thenThrow(Exception('Test error'));

      final result = await storageService.write(key, value);

      expect(
          result,
          equals(
              const StorageFailure(message: "Not able to write in storage")));
    });

    test('deleteAll should return null on success', () async {
      when(mockStorage.deleteAll()).thenAnswer((_) => Future.value());

      final result = await storageService.deleteAll();

      expect(result, isNull);
    });

    test('deleteAll should return StorageFailure on error', () async {
      when(mockStorage.deleteAll()).thenThrow(Exception('Test error'));

      final result = await storageService.deleteAll();

      expect(result, equals(const StorageFailure(message: "unable to delete")));
    });

    test('deleteValue should return null on success', () async {
      const key = 'testKey';

      when(mockStorage.delete(key: key)).thenAnswer((_) => Future.value());

      final result = await storageService.deleteValue(key);

      expect(result, isNull);
    });

    test('deleteValue should return StorageFailure on error', () async {
      const key = 'testKey';

      when(mockStorage.delete(key: key)).thenThrow(Exception('Test error'));

      final result = await storageService.deleteValue(key);

      expect(result, equals(const StorageFailure(message: "unable to delete")));
    });
  });
}
