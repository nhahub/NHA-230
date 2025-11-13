import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tal3a/features/home/services/search_service.dart';
import 'package:tal3a/features/home/widgets/place_card.dart';
import 'package:tal3a/core/constants/app_colors.dart';

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
        elevation: 0,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search places...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor,
            hintStyle: TextStyle(color: theme.hintColor),
            prefixIcon: const Icon(Icons.search),
          ),
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          onChanged: _performSearch,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty && _searchController.text.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text('No results found', style: theme.textTheme.bodyLarge),
                    ],
                  ),
                )
              : _searchController.text.isEmpty
                  ? Center(
                      child: Text(
                        'Start typing to search',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16.w),
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: PlaceCard(
                            name: place['name'] ?? 'Unknown',
                            address: place['address'] ?? 'No address',
                            imageUrl: place['image'] ?? '',
                            onTap: () {
                              // Navigate to place details
                              Navigator.pushNamed(
                                context,
                                '/place-info',
                                arguments: {
                                  ...place,
                                  'collectionName': place['category'],
                                },
                              );
                            },
                          ),
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
