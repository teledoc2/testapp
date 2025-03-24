import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeScreenProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home Screen'),
          centerTitle: true,
        ),
        body: Consumer<HomeScreenProvider>(
          builder: (context, provider, child) {
            return provider.getSelectedPage();
          },
        ),
        bottomNavigationBar: Consumer<HomeScreenProvider>(
          builder: (context, provider, child) {
            return BottomNavigationBar(
              currentIndex: provider.currentIndex,
              onTap: provider.updateIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  label: 'Favorites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Define your primary action here
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class HomeScreenProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  Widget getSelectedPage() {
    switch (_currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      case 2:
        return FavoritesPage();
      case 3:
        return ProfilePage();
      default:
        return HomePage();
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(Icons.article),
            title: Text('Item ${index + 1}'),
            subtitle: Text('Subtitle for item ${index + 1}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle card tap
            },
          ),
        );
      },
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Search Page'),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Favorites Page'),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Page'),
    );
  }
}
