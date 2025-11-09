import 'package:flutter/material.dart';
import 'package:tal3a/features/home/services/search_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchService _searchService = SearchService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _performSearch(String searchTerm) async {
    if (searchTerm.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    setState(() => _isLoading = true);
    final results = await _searchService.searchPlaces(searchTerm);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search places...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: theme.hintColor),
          ),
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          onChanged: _performSearch,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final place = _searchResults[index];
                    return ListTile(
                      title: Text(place['name'] ?? ''),
                      subtitle: Text(place['description'] ?? ''),
                      onTap: () {
                        // Navigate to place details
                        // Navigator.pushNamed(context, '/place-details', arguments: place);
                      },
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}