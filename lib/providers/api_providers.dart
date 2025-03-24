import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Repository for API calls
class ApiRepository {
  final String baseUrl;

  ApiRepository({required this.baseUrl});

  Future<Map<String, dynamic>> fetchPages() async {
    final response = await http.get(Uri.parse('$baseUrl/pages'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load pages');
    }
  }
}

// ChangeNotifier for managing page data
class PageProvider with ChangeNotifier {
  final ApiRepository apiRepository;

  PageProvider({required this.apiRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<dynamic> _pages = [];
  List<dynamic> get pages => _pages;

  Future<void> fetchPages() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await apiRepository.fetchPages();
      _pages = data['pages'] ?? [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void retryFetchPages() {
    fetchPages();
  }
}

// Main App
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiRepository>(
          create: (_) => ApiRepository(baseUrl: 'https://example.com'),
        ),
        ChangeNotifierProvider<PageProvider>(
          create: (context) => PageProvider(
            apiRepository: context.read<ApiRepository>(),
          ),
        ),
      ],
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

// Home Page
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pageProvider = context.watch<PageProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: pageProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : pageProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${pageProvider.error}'),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: pageProvider.retryFetchPages,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: pageProvider.pages.length,
                  itemBuilder: (context, index) {
                    final page = pageProvider.pages[index];
                    return ListTile(
                      title: Text(page['title']),
                      subtitle: Text(page['url']),
                    );
                  },
                ),
    );
  }
}
