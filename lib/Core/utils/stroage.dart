import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:invisquery/Core/Errors/failure.dart';

class StorageService {
  final FlutterSecureStorage storageService;
  StorageService(this.storageService);

  Future<(Failure?, String?)> readStorage(String key) async {
    try {
      String? value = await storageService.read(key: key);

      if (value == null) {
        return (const StorageFailure(message: "Required key not found"), null);
      }

      return (null, value);
    } catch (e) {
      log(e.toString());
      return (const StorageFailure(), null);
    }
  }

  Future<Failure?> write(String key, String value) async {
    try {
      await storageService.write(key: key, value: value);
      return null;
    } catch (e) {
      log(e.toString());
      return (const StorageFailure(message: "Not able to write in storage"));
    }
  }

  Future<Failure?> deleteAll() async {
    try {
      await storageService.deleteAll();
      return null;
    } catch (e) {
      log(e.toString());
      return (const StorageFailure(message: "unable to delete"));
    }
  }

  Future<Failure?> deleteValue(String key) async {
    try {
      await storageService.delete(key: key);
      return null;
    } catch (e) {
      log(e.toString());
      return (const StorageFailure(message: "unable to delete"));
    }
  }
}
