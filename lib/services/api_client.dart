import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client httpClient;

  ApiClient({required this.baseUrl, http.Client? client})
      : httpClient = client ?? http.Client();

  Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await httpClient.get(url);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await httpClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Error: ${response.statusCode}, Body: ${response.body}');
    }
  }

  void dispose() {
    httpClient.close();
  }
}

class ApiService {
  final ApiClient apiClient;

  ApiService({required this.apiClient});

  Future<dynamic> fetchHomePage() async {
    return await apiClient.get('/');
  }
}

void main() async {
  final apiClient = ApiClient(baseUrl: 'https://example.com');
  final apiService = ApiService(apiClient: apiClient);

  try {
    final homePageData = await apiService.fetchHomePage();
    print('Home Page Data: $homePageData');
  } catch (e) {
    print('Error: $e');
  } finally {
    apiClient.dispose();
  }
}
