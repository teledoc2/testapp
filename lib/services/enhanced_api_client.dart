import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  final Dio _dio;

  ApiClient._internal(this._dio);

  factory ApiClient({required String baseUrl}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.addAll([
      _AuthInterceptor(),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);

    return ApiClient._internal(dio);
  }

  Future<Response> getHomePage() async {
    try {
      final response = await _dio.get('/');
      return response;
    } on DioError catch (e) {
      rethrow;
    }
  }
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Add token logic if needed
    handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh logic if needed
      handler.next(err);
    } else {
      handler.next(err);
    }
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('Request: ${options.method} ${options.uri}');
      print('Headers: ${options.headers}');
      print('Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('Response: ${response.statusCode} ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('Error: ${err.response?.statusCode} ${err.message}');
    }
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String errorMessage = 'An unknown error occurred';
    if (err.type == DioErrorType.connectTimeout) {
      errorMessage = 'Connection timeout';
    } else if (err.type == DioErrorType.receiveTimeout) {
      errorMessage = 'Receive timeout';
    } else if (err.type == DioErrorType.response) {
      errorMessage = 'Server error: ${err.response?.statusCode}';
    } else if (err.type == DioErrorType.other && err.error is SocketException) {
      errorMessage = 'No internet connection';
    }

    err.error = errorMessage;
    handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  RetryInterceptor({required this.dio, this.maxRetries = 3});

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err) && maxRetries > 0) {
      try {
        final response = await _retry(err.requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetry(DioError err) {
    return err.type == DioErrorType.other || err.type == DioErrorType.response;
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

class EnvironmentConfig {
  static const String devBaseUrl = 'https://dev.example.com';
  static const String prodBaseUrl = 'https://example.com';

  static String getBaseUrl({bool isProduction = false}) {
    return isProduction ? prodBaseUrl : devBaseUrl;
  }
}
