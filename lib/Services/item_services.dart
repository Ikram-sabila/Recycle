import 'package:firebase_database/firebase_database.dart';
import 'package:project/Firebase/firebase_config.dart';

class ItemService {
  final DatabaseReference _itemRef = FirebaseConfig.getDatabaseReference('Items');

  Future<int> getLastId() async {
    try {
      final snapshot = await _itemRef.once();
      if (snapshot.snapshot.value == null) {
        return 1;
      }
      final Map<dynamic, dynamic> items = snapshot.snapshot.value as Map<dynamic, dynamic>;
      final ids = items.keys.map((key) => int.tryParse(key) ?? 0).toList();
      ids.sort();
      return ids.isEmpty ? 1 : ids.last + 1;
    } catch (e) {
      print('Gagal mendapatkan ID terakhir: $e');
      return 1;
    }
  }

  Future<void> addItem ({
    required String name,
    required String description,
    required String group,
    required String image,
    required String recycle,
  }) async {
    try {
      final id = await getLastId();

      await _itemRef.child(id.toString()).set({
        'name': name,
        'Description': description,
        'Group': group,
        'Image': image,
        'Recycle': recycle
      });
      print('item telah ditambahkan');
    } catch (e) {
      print('Gagal menambahkan item: $e');
    }
  }
}