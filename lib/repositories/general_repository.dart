// Abstract Repository Interface
abstract class GeneralRepository {
  Future<T> fetchData<T>(String endpoint);
  Future<void> postData<T>(String endpoint, Map<String, dynamic> data);
  Future<void> updateData<T>(String endpoint, Map<String, dynamic> data);
  Future<void> deleteData(String endpoint);
}

// Concrete Implementation
import 'dart:convert';
import 'package:http/http.dart' as http;

class GeneralRepositoryImpl implements GeneralRepository {
  final http.Client apiClient;
  final Map<String, dynamic> _cache = {};

  GeneralRepositoryImpl(this.apiClient);

  @override
  Future<T> fetchData<T>(String endpoint) async {
    try {
      if (_cache.containsKey(endpoint)) {
        return _cache[endpoint] as T;
      }

      final response = await apiClient.get(Uri.parse(endpoint));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cache[endpoint] = data;
        return data as T;
      } else {
        throw _mapError(response);
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> postData<T>(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 201) {
        throw _mapError(response);
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> updateData<T>(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put(
        Uri.parse(endpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      if (response.statusCode != 200) {
        throw _mapError(response);
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  @override
  Future<void> deleteData(String endpoint) async {
    try {
      final response = await apiClient.delete(Uri.parse(endpoint));
      if (response.statusCode != 200) {
        throw _mapError(response);
      }
    } catch (e) {
      throw _handleException(e);
    }
  }

  Exception _mapError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        return BadRequestException(response.body);
      case 401:
        return UnauthorizedException(response.body);
      case 404:
        return NotFoundException(response.body);
      case 500:
        return ServerException(response.body);
      default:
        return UnknownException('Unknown error occurred');
    }
  }

  Exception _handleException(dynamic e) {
    if (e is http.ClientException) {
      return NetworkException(e.message);
    }
    return UnknownException(e.toString());
  }
}

// Custom Exceptions
class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);
}
