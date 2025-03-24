import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  String _selectedSort = 'Ascending';
  List<String> _items = ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry'];
  List<String> _filteredItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(_items);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFiltersAndSorting();
    });
  }

  void _applyFiltersAndSorting() {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;

        // Filter items
        _filteredItems = _items.where((item) {
          if (_selectedFilter == 'All') {
            return item.toLowerCase().contains(_searchQuery.toLowerCase());
          }
          return item.toLowerCase().startsWith(_searchQuery.toLowerCase());
        }).toList();

        // Sort items
        if (_selectedSort == 'Ascending') {
          _filteredItems.sort();
        } else {
          _filteredItems.sort((a, b) => b.compareTo(a));
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred while filtering and sorting.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () => _showSortDialog(),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged();
                      },
                    ),
                  ),
                  onChanged: (value) => _onSearchChanged(),
                ),
                SizedBox(height: 16),
                if (_isLoading)
                  Center(child: CircularProgressIndicator())
                else if (_errorMessage != null)
                  Center(child: Text(_errorMessage!))
                else
                  Expanded(
                    child: _filteredItems.isEmpty
                        ? Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_filteredItems[index]),
                              );
                            },
                          ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Filter'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('All'),
                value: 'All',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value.toString();
                    _applyFiltersAndSorting();
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text('Starts with'),
                value: 'Starts with',
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value.toString();
                    _applyFiltersAndSorting();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Sort Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text('Ascending'),
                value: 'Ascending',
                groupValue: _selectedSort,
                onChanged: (value) {
                  setState(() {
                    _selectedSort = value.toString();
                    _applyFiltersAndSorting();
                  });
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: Text('Descending'),
                value: 'Descending',
                groupValue: _selectedSort,
                onChanged: (value) {
                  setState(() {
                    _selectedSort = value.toString();
                    _applyFiltersAndSorting();
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
