class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message (Status Code: $statusCode)';
}

class NetworkException extends ApiException {
  NetworkException([String message = 'No internet connection.'])
      : super(message);
}

class ServerException extends ApiException {
  ServerException([String message = 'Server error occurred.'])
      : super(message, 500);
}

class ClientException extends ApiException {
  ClientException(String message, [int? statusCode])
      : super(message, statusCode);
}

class AuthenticationException extends ApiException {
  AuthenticationException([String message = 'Authentication error.'])
      : super(message, 401);
}

class ValidationException extends ApiException {
  final Map<String, dynamic>? validationErrors;

  ValidationException(String message, [this.validationErrors])
      : super(message, 422);

  @override
  String toString() {
    if (validationErrors != null) {
      return 'ValidationException: $message (Errors: $validationErrors)';
    }
    return super.toString();
  }
}

class ApiExceptionHelper {
  static String getFriendlyMessage(ApiException exception) {
    if (exception is NetworkException) {
      return 'Please check your internet connection and try again.';
    } else if (exception is ServerException) {
      return 'Our servers are currently unavailable. Please try again later.';
    } else if (exception is AuthenticationException) {
      return 'You are not authorized to perform this action. Please log in.';
    } else if (exception is ValidationException) {
      return 'There are validation errors. Please check your input.';
    } else if (exception is ClientException) {
      return 'An error occurred. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
