import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String groupId;
  final String groupName;

  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final String userUid = FirebaseAuth.instance.currentUser!.uid;

    Future<String> getSenderName(String userUid) async {
      final databaseRef = FirebaseDatabase.instance.ref('users/$userUid');
      final snapshot = await databaseRef.get();

      if(snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        return data['name'] ?? "Anonymus";
      } else {
        return 'unknown';
      }
    }

    Color getColor(String uid){
      final hash = uid.hashCode;
      final r = (hash & 0xFF0000) >> 16;
      final g = (hash & 0x00FF00) >> 8;
      final b = (hash & 0x0000FF);
      return Color.fromARGB(255, r, g, b);
    }

    void sendMessage() async {
      if (messageController.text.trim().isEmpty) return;

      final userName = await getSenderName(userUid);

      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('messages')
          .add({
        'senderId': userUid,
        'senderName': userName,
        'message': messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(title: Text(groupName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('groups')
                  .doc(groupId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index].data() as Map<String, dynamic>;
                    bool isMe = message['senderId'] == userUid;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
                          children: [
                            if (!isMe)
                              const CircleAvatar(
                                backgroundImage: NetworkImage("https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174401.jpg?semt=ais_hybrid"),
                                radius: 20,
                              ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if(!isMe)
                                    Text(
                                      message['senderName'],
                                      style: TextStyle(
                                        color: getColor(message['senderId']),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  Text(
                                    message['message'],
                                    style: TextStyle(color: isMe ? Colors.white : Colors.black),
                                  ),
                                  // Text("Sender ID: ${message['senderId']}"),
                                  // Text("Current UID: $userUid"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
