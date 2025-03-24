import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      theme: settingsProvider.isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: SettingsScreen(),
    );
  }
}

class SettingsProvider extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool _notificationsEnabled = true;

  bool get isDarkTheme => _isDarkTheme;
  bool get notificationsEnabled => _notificationsEnabled;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('App Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
                    'Preferences',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  SwitchListTile(
                    title: Text('Dark Theme'),
                    value: settingsProvider.isDarkTheme,
                    onChanged: (value) {
                      try {
                        settingsProvider.toggleTheme();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error toggling theme')),
                        );
                      }
                    },
                  ),
                  SwitchListTile(
                    title: Text('Enable Notifications'),
                    value: settingsProvider.notificationsEnabled,
                    onChanged: (value) {
                      try {
                        settingsProvider.toggleNotifications();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error toggling notifications')),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Other Settings',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text('Account Settings'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to account settings
                    },
                  ),
                  ListTile(
                    title: Text('Privacy Policy'),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
