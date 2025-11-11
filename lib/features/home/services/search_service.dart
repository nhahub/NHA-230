import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final List<String> _collections = [
    'restaurants',
    'cafes',
    'malls',
    'beaches',
    'tourist_attractions',
    'amusement_parks'
  ];

  Future<List<Map<String, dynamic>>> searchPlaces(String searchTerm) async {
    if (searchTerm.isEmpty) return [];

    try {
      List<Map<String, dynamic>> allResults = [];

      for (String collectionName in _collections) {
        QuerySnapshot querySnapshot = await _firestore
            .collection(collectionName)
            .where('name', isGreaterThanOrEqualTo: searchTerm)
            .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
            .get();

        for (var doc in querySnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          data['category'] = collectionName; // Add category for identification
          data['docId'] = doc.id;
          allResults.add(data);
        }
      }

      return allResults;
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }
}
