import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final databaseRef = FirebaseDatabase.instance.ref("users");
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  // late String name;
  // late String number;

  final User? user = FirebaseAuth.instance.currentUser;

  Widget input(String judul, String input, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(judul),
        const SizedBox(height: 5,),
        TextField(
          controller: controller,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: input,
          ),
        ),
        const SizedBox(height: 10,),
      ],
    );
  }

  Widget _buttonAdd () {
    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        onPressed: addData,
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

  void addData() async {
    String name = nameController.text;
    String number = numberController.text;

    if (name.isEmpty || number.isEmpty) {
      print("Nama atau Nomor HP tidak boleh kosong");
      return;
    }

    try {
      await databaseRef.child(user!.uid).set({
        'name': name,
        'number': number,
      });
      print("Data berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan data: $e");
    }

    nameController.clear();
    numberController.clear();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.all(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    "https://img.freepik.com/free-vector/smiling-young-man-illustration_1308-174401.jpg?semt=ais_hybrid"),
              ),
            ),
            const SizedBox(height: 10,),
            input("Nama", "Masukkan Nama", nameController),
            input("Nomor Handphone", "Masukkan Nomor HP", numberController),
            _buttonAdd(),
          ],
        ),
      ),
    );
  }
}
