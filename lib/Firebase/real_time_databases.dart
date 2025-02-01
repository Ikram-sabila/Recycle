import 'package:firebase_database/firebase_database.dart';

class RealTimeDatabase {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> fetchItems() async {
    try {
      final snapshot = await _databaseReference.child('items').get();
      if(snapshot.exists) {
        final items = snapshot.value as Map<dynamic, dynamic>;
        return items.entries.map((entry) {
          return {
            "name": entry.value["name"] ?? "",
            "image": entry.value["image"] ?? "",
          };
        }).toList();
      }
    } catch (e) {
      print("Failed to fetch items: $e");
    }
    return [];
  }
}