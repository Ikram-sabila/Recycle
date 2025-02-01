import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream<List<Group>> getGroups() {
  //   return _firestore.collection('groups').snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return Group.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  //     }).toList();
  //   });
  // }
  Stream<QuerySnapshot> getGroups(){
    return _firestore.collection('groups').snapshots();
  }

  Future<void> createGroup(String name, String imageUrl, String userId) async {
    await _firestore.collection('groups').add({
      'name': name,
      'image': imageUrl,
      'members': [userId],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> joinGroup(String groupId, String userId) async {
    await _firestore.collection('groups').doc(groupId).update({
      'members': FieldValue.arrayUnion([userId]),
    });
  }
}
