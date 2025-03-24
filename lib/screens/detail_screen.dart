import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ContentProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detail View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DetailScreen(),
    );
  }
}

class ContentProvider extends ChangeNotifier {
  String? _content;
  String? _error;

  String? get content => _content;
  String? get error => _error;

  void fetchContent() async {
    try {
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      _content = "This is the detailed content fetched from the server.";
      _error = null;
    } catch (e) {
      _error = "Failed to load content.";
      _content = null;
    }
    notifyListeners();
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail View'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Content Details',
                  style: TextStyle(
                    fontSize: constraints.maxWidth > 600 ? 24 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: contentProvider.error != null
                      ? Center(
                          child: Text(
                            contentProvider.error!,
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : contentProvider.content == null
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : SingleChildScrollView(
                              child: Text(
                                contentProvider.content!,
                                style: TextStyle(
                                  fontSize: constraints.maxWidth > 600 ? 18 : 14,
                                ),
                              ),
                            ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    contentProvider.fetchContent();
                  },
                  child: Text('Reload Content'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
