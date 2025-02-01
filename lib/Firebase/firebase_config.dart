import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  static DatabaseReference getDatabaseReference(String path) {
    return FirebaseDatabase.instance.ref(path);
  }
}