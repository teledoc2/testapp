import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserProfileScreen(),
    );
  }
}

class UserProfileProvider extends ChangeNotifier {
  String _username = "John Doe";
  String _email = "johndoe@example.com";
  bool _isLoading = false;
  String? _errorMessage;

  String get username => _username;
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void updateProfile(String username, String email) {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    Future.delayed(Duration(seconds: 2), () {
      if (username.isEmpty || email.isEmpty) {
        _errorMessage = "Fields cannot be empty";
      } else {
        _username = username;
        _email = email;
      }
      _isLoading = false;
      notifyListeners();
    });
  }
}

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  provider.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Username: ${provider.username}"),
                            SizedBox(height: 10),
                            Text("Email: ${provider.email}"),
                            SizedBox(height: 20),
                            if (provider.errorMessage != null)
                              Text(
                                provider.errorMessage!,
                                style: TextStyle(color: Colors.red),
                              ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _showEditProfileDialog(context, provider);
                              },
                              child: Text("Edit Profile"),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, UserProfileProvider provider) {
    final usernameController =
        TextEditingController(text: provider.username);
    final emailController = TextEditingController(text: provider.email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateProfile(
                  usernameController.text,
                  emailController.text,
                );
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: Text("Settings Screen"),
      ),
    );
  }
}
