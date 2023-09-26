import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:invisquery/Core/Errors/failure.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/constant.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pretty_http_logger/pretty_http_logger.dart';

import 'network_test.mocks.dart';

@GenerateMocks([InternetConnectionCheckerPlus])
@GenerateMocks([HttpWithMiddleware])
void main() {
  group('NetworkServiceImpl', () {
    late NetworkServiceImpl networkServiceImpl;
    late InternetConnectionCheckerPlus connectionChecker;
    late APIInfo apiInfo;

    late MockHttpWithMiddleware httpClient;
    setUpAll(() {
      connectionChecker = MockInternetConnectionCheckerPlus();
      apiInfo = APIInfo();
      httpClient = MockHttpWithMiddleware();
      networkServiceImpl = NetworkServiceImpl(connectionChecker, httpClient);
    });

    group('check connection', () {
      group('if connection available', () {
        setUpAll(() {
          when(connectionChecker.hasConnection).thenAnswer((_) async => true);
        });
        group('get-request', () {
          test('should return API Response if get request is successful',
              () async {
            // Arrange
            const tEndpoint = '/example';
            final tQueryParameters = {'query': '1'};
            var url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
            url = url.replace(queryParameters: tQueryParameters);

            // Mock the HTTP response
            final response = http.Response(
                '{"status_code": 200, "message": "Success fully authenticated", "data": [], "success": true}',
                200);

            when(httpClient.get(
              url,
              headers: apiInfo.defaultHeader,
            )).thenAnswer((_) async => response);

            // Act
            final result = await networkServiceImpl.get(
                headers: apiInfo.defaultHeader,
                endpoint: tEndpoint,
                query: tQueryParameters);

            // Assert
            expect(result.$1, isNull);
            expect(result.$2, isNotNull);
            expect(result.$2!.statusCode, 200);
            expect(result.$2!.success, isTrue);
          });
          test('should return EndPoint if get is unsuccessful', () async {
            // Arrange
            const tEndpoint = '/example';
            final tQueryParameters = {'query': '1'};
            var url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
            url = url.replace(queryParameters: tQueryParameters);
            // Mock the HTTP response
            final response = http.Response(
                jsonEncode(
                    '{"status_code": 404, "message": "Not found", "data": [], "success": false}'),
                404);

            when(httpClient.get(
              url,
              headers: apiInfo.defaultHeader,
            )).thenAnswer((_) async => response);

            // Act
            final result = await networkServiceImpl.get(
                headers: apiInfo.defaultHeader,
                endpoint: tEndpoint,
                query: tQueryParameters);

            // Assert
            expect(result.$2, isNull);
            expect(result.$1, isNotNull);
          });
        });
        group('post-request', () {
          test('should return API Response if post request is successful',
              () async {
            // Arrange
            const tEndpoint = '/example';

            final tBody = {'request': 100};
            var url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));

            // Mock the HTTP response
            final response = http.Response(
                '{"status_code": 200, "message": "Successfully data sent", "data": [], "success": true}',
                200);

            when(httpClient.post(url,
                    headers: apiInfo.defaultHeader, body: jsonEncode(tBody)))
                .thenAnswer((_) async => response);

            // Act
            final result =
                await networkServiceImpl.post(endpoint: tEndpoint, data: tBody);

            // Assert
            expect(result.$1, isNull);
            expect(result.$2, isNotNull);
            expect(result.$2!.statusCode, 200);
            expect(result.$2!.success, isTrue);
          });
          test('should return Failure if post is unsuccessful', () async {
            // Arrange
            const tEndpoint = '/example';

            final tBody = {'request': 100};
            var url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
            // Mock the HTTP response
            final response = http.Response(
                '{"status_code": 404, "message": "Succeed post request", "data": [], "success": false}',
                404);
            when(connectionChecker.hasConnection).thenAnswer((_) async => true);
            when(httpClient.post(url,
                    headers: apiInfo.defaultHeader, body: jsonEncode(tBody)))
                .thenAnswer((_) async => response);

            // Act
            final result =
                await networkServiceImpl.post(endpoint: tEndpoint, data: tBody);

            // Assert
            expect(result.$2, isNull);
            expect(result.$1, isNotNull);
          });
        });
      });

      group('if not internet available', () {
        setUpAll(() {
          when(connectionChecker.hasConnection).thenAnswer((_) async => false);
        });

        group('get-request', () {
          test(
              'should return Internet failure if get is unsuccessful due to no connectivity',
              () async {
            // Arrange
            const tEndpoint = '/example';
            final tQueryParameters = {'query': '1'};
            var url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));
            url = url.replace(queryParameters: tQueryParameters);
            // Mock the HTTP response
            final response = http.Response(
                '{"status_code": 404, "message": "Not found", "data": [], "success": false}',
                404);

            when(httpClient.get(
              url,
              headers: apiInfo.defaultHeader,
            )).thenAnswer((_) async => response);

            // Act
            final result = await networkServiceImpl.get(
                headers: apiInfo.defaultHeader,
                endpoint: tEndpoint,
                query: tQueryParameters);

            // Assert
            expect(result.$2, isNull);
            expect(result.$1, isNotNull);
            expect(result.$1, isA<InternetConnectionFailure>());
          });
        });

        group('post-request', () {
          test(
              'should return InternetConnectionFailure if no internet available for post request',
              () async {
            // Arrange
            const tEndpoint = '/example';
            final tBody = {'query': '1'};
            var url = Uri.parse(networkServiceImpl.buildUrl(tEndpoint));

            // Mock the HTTP response
            final response = http.Response(
                jsonEncode(
                    '{"status_code": 404, "message": "Not found", "data": [], "success": false}'),
                404);

            when(httpClient.post(url,
                    headers: apiInfo.defaultHeader, body: jsonEncode(tBody)))
                .thenAnswer((_) async => response);

            // Act
            final result = await networkServiceImpl.post(
                headers: apiInfo.defaultHeader,
                endpoint: tEndpoint,
                data: tBody);

            // Assert
            expect(result.$2, isNull);
            expect(result.$1, isNotNull);

            expect(result.$1, isA<InternetConnectionFailure>());
          });
        });
      });
    });
  });
}
