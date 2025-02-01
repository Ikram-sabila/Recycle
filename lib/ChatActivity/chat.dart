import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_card.dart';
import 'chat_page.dart';
import '../services/group_services.dart';

class Chat extends StatelessWidget {
  final GroupService groupService = GroupService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  Chat({Key? key}) : super(key: key);

  Widget _buttonAdd(TextEditingController name, TextEditingController imageUrl,
      String uid) {
    String nama = name.text;
    String gambar = imageUrl.text;

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        onPressed: () {
          groupService.createGroup(nama, gambar, uid);
          name.clear();
          imageUrl.clear();
        },
        child: const Text(
          "Add",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _box(String nama, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: backgroundColor: color,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          // onTap: ,
          child: Row(
            children: [
              Icon(
                icon,
                size: 30,
              ),
              SizedBox(width: 10,),
              Text(
                nama,
                style: const TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Groups"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Create Groups"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Masukkan nama grup",
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: imageController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Masukkan link gambar",
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buttonAdd(nameController, imageController, userId),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Row with two boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _box("Rules", Icons.book)),
              Expanded(child: _box("Add", Icons.newspaper)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder(
              stream: groupService.getGroups(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var groups = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  itemCount: groups.docs.length,
                  itemBuilder: (context, index) {
                    var groupData = groups.docs[index].data() as Map<
                        String,
                        dynamic>;
                    var groupId = groups.docs[index].id;
                    return ChatCard(
                      groupId: groupId,
                      groupName: groupData['name'],
                      groupImageUrl: groupData['image'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ChatPage(
                                  groupId: groupId,
                                  groupName: groupData['name'],
                                ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
